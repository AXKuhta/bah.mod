' Copyright (c) 2009-2016 Bruce A Henderson
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
'
SuperStrict

Rem
bbdoc: OpenCL
End Rem
Module BaH.OpenCL

ModuleInfo "Version: 1.01"
ModuleInfo "Author: Bruce A Henderson"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: (opencl) 2008-2009 The Khronos Group Inc."
ModuleInfo "Copyright: (wrapper) 2009-2016 Bruce A Henderson"

ModuleInfo "History: 1.01"
ModuleInfo "History: Updated for NG."
ModuleInfo "History: 1.00 Initial Release"

?win32
ModuleInfo "LD_OPTS: -L%PWD%/lib/win32"
?

Import "common.bmx"


Extern
	Function bmx_ocl_platform_getdevices:TCLDevice[](deviceType:Int)
End Extern

Rem
bbdoc: The platform allows the host program to discover OpenCL devices and their capabilities and to create contexts.
End Rem
Type TCLPlatform

	Field platformPtr:Byte Ptr
	Field device:TCLDevice
	
	Rem
	bbdoc: Initialises the platform using the specified device.
	End Rem
	Function InitPlatform:TCLPlatform(device:TCLDevice)
		Local this:TCLPlatform = New TCLPlatform
		this.platformPtr = bmx_ocl_platform_init(this, device.devicePtr)
		this.device = device
		Return this
	End Function
	
	Rem
	bbdoc: Initialises the platform using a given device type.
	about: If @deviceType refers to more than one device, the first available device is used.
	<p>Parameters:
	<ul>
	<li><b>deviceType</b> :  A bitfield that identifies the type of OpenCL device. The valid values for @deviceType are, 
	#CL_DEVICE_TYPE_CPU, #CL_DEVICE_TYPE_GPU, #CL_DEVICE_TYPE_ACCELERATOR, #CL_DEVICE_TYPE_DEFAULT and #CL_DEVICE_TYPE_ALL.</li>
	</ul>
	</p>
	End Rem
	Function InitDevice:TCLPlatform(deviceType:Int)
		Local devices:TCLDevice[] = GetDevices(deviceType)
		If devices.length > 0 Then
			Local device:TCLDevice = devices[0]
	
			Local this:TCLPlatform = New TCLPlatform
			this.platformPtr = bmx_ocl_platform_init(this, device.devicePtr)
			this.device = device
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Returns the list of devices available on the platform.
	about: @deviceType is a bitfield that identifies the type of OpenCL device.
	The @deviceType can be used to query specific OpenCL devices or all OpenCL devices available. The valid values for @deviceType are, 
	#CL_DEVICE_TYPE_CPU, #CL_DEVICE_TYPE_GPU, #CL_DEVICE_TYPE_ACCELERATOR, #CL_DEVICE_TYPE_DEFAULT and #CL_DEVICE_TYPE_ALL.
	End Rem
	Function GetDevices:TCLDevice[](deviceType:Int = CL_DEVICE_TYPE_ALL)
		Return bmx_ocl_platform_getdevices(deviceType)
	End Function
	
	Rem
	bbdoc: Creates a program by loading the @source, returning a new #TCLProgram object.
	End Rem
	Method LoadProgram:TCLProgram(source:Object)
		Local Text:String
		If String(source) Then
			Text = String(source)
		Else If TStream(source) Then
			Text = LoadString(source)
		End If
		
		Return TCLProgram.Load(Self, Text) 
	End Method
	
	Rem
	bbdoc: Creates a buffer object.
	about: Parameters:
	<ul>
	<li><b>flags</b> : A bit-field that is used to specify allocation and usage information such as the memory
	arena that should be used to allocate the buffer object and how it will be used. Can be one or more of #CL_MEM_READ_WRITE, 
	#CL_MEM_WRITE_ONLY, #CL_MEM_READ_ONLY, #CL_MEM_USE_HOST_PTR, #CL_MEM_ALLOC_HOST_PTR and #CL_MEM_COPY_HOST_PTR.</li>
	<li><b>size</b> : The size in bytes of the buffer memory object to be allocated. </li>
	<li><b>hostPtr</b> : A pointer to the buffer data that may already be allocated by the application.
	The size of the buffer that @hostPtr points to must be greater than or equal to the @size bytes.</li>
	</ul>
	End Rem
	Method CreateBuffer:TCLBuffer(flags:Int, size:Int, hostPtr:Byte Ptr = Null)
		Return TCLBuffer.Create(Self, flags, size, hostPtr)
	End Method
	
	Rem
	bbdoc: Creates a 2D image object.
	about: 
	End Rem
	Method CreateImage2D:TCLImage(flags:Int, channelOrder:Int, imageType:Int, width:Int, height:Int, rowPitch:Int, hostPtr:Byte Ptr)
		Return TCLImage.Create2D(Self, flags, channelOrder, imageType, width, height, rowPitch, hostPtr)
	End Method
	
	Rem
	bbdoc: Creates a 3D image object.
	End Rem
	Method CreateImage3D:TCLImage(flags:Int, channelOrder:Int, imageType:Int, width:Int, height:Int, depth:Int, rowPitch:Int, slicePitch:Int, hostPtr:Byte Ptr)
		Return TCLImage.Create3D(Self, flags, channelOrder, imageType, width, height, depth, rowPitch, slicePitch, hostPtr)
	End Method
	
	Rem
	bbdoc: Issues all previously queued OpenCL commands in the queue to the device.
	returns: CL_SUCCESS if the call was executed successfully. It returns CL_INVALID_COMMAND_QUEUE if queue is not a valid command-queue and returns CL_OUT_OF_HOST_MEMORY if there is a failure to allocate resources required by the OpenCL implementation on the host.
	about: Flush only guarantees that all queued commands to to the queue get issued to the appropriate device.
	There is no guarantee that they will be complete after Flush returns.
	<p>
	Any blocking commands queued in a command-queue such as EnqueueRead{Image|Buffer} with blockingRead set to TRUE, EnqueueWrite{Image|Buffer} with
	blockingWrite set to True, EnqueueMap{Buffer|Image} with blockingMap set to True or WaitForEvents perform an implicit flush of the command-queue.
	</p>
	<p>
	To use event objects that refer to commands enqueued in a command-queue as event objects to wait on by commands enqueued in a different
	command-queue, the application must call a Flush or any blocking commands that perform an implicit flush of the command-queue where the
	commands that refer to these event objects are enqueued.
	</p>
	End Rem
	Method Flush()
		bmx_ocl_platform_flush(platformPtr)
	End Method
	
	Rem
	bbdoc: Blocks until all previously queued OpenCL commands in the queue are issued to the associated device and have completed.
	returns: CL_SUCCESS if the call was executed successfully.	It returns CL_INVALID_COMMAND_QUEUE if the queue is not a valid command-queue and returns CL_OUT_OF_HOST_MEMORY if there is a failure to allocate resources required by the OpenCL implementation on the host.
	about: Finish does not return until all queued commands in the queue have been processed and completed. Finish is also a synchronization point.
	End Rem
	Method Finish()
		bmx_ocl_platform_finish(platformPtr)
	End Method
	
End Type

Rem
bbdoc: An OpenCL device.
End Rem
Type TCLDevice

	Field devicePtr:Byte Ptr
	Field deviceType:Int
	
	Function _create:TCLDevice(devicePtr:Byte Ptr) { nomangle }
		If devicePtr Then
			Local this:TCLDevice = New TCLDevice
			this.devicePtr = devicePtr
			Return this
		End If
	End Function
	
	Function _newDeviceList:TCLDevice[](count:Int) { nomangle }
		Return New TCLDevice[count]
	End Function
	
	Function _setDevice:TCLDevice(list:TCLDevice[], index:Int, devicePtr:Byte Ptr, deviceType:Int) { nomangle }
		Local device:TCLDevice = _create(devicePtr)
		device.deviceType = deviceType
		list[index] = device
		Return device
	End Function

	Rem
	bbdoc: Returns information about the device.
	End Rem
	Method GetInfo:TCLDeviceInfo()
		Return TCLDeviceInfo(bmx_ocl_device_getinfo(devicePtr))
	End Method

	Method Delete()
		If devicePtr Then
			bmx_ocl_device_free(devicePtr)
			devicePtr = Null
		End If
	End Method
	
End Type

Rem
bbdoc: Device information
End Rem
Type TCLDeviceInfo

	Rem
	bbdoc: Vendor name.
	End Rem
	Field vendorName:String
	Rem
	bbdoc: Device name.
	End Rem
	Field deviceName:String
	Rem
	bbdoc: OpenCL software driver version in the form major_number.minor_number.
	End Rem
	Field driverVersion:String
	Rem
	bbdoc: OpenCL version.
	about: Returns the OpenCL version supported by the device.
	This version string has the following format:
	</pre>
	OpenCL&lt;space&gt;&lt;major_version.min or_version&gt;&lt;space&gt;&lt;vendor-specific information&gt;
	</pre>
	The major_version.minor_version value returned will be 1.0.
	End Rem
	Field deviceVersion:String
	Rem
	bbdoc: The number of parallel compute cores on the OpenCL device.
	about: The minimum value is 1.
	End Rem
	Field maxComputeUnits:Int
	Rem
	bbdoc: Maximum dimensions that specify the global and local work-item IDs used by the data parallel execution model.
	about: (Refer to clEnqueueNDRangeKernel). The minimum value is 3.
	End Rem
	Field maxWorkItemDimensions:Int
	Rem
	bbdoc: Maximum number of work-items that can be specified in each dimension of the work-group to clEnqueueNDRangeKernel.
	about: Returns @n entries, where @n equals the value of #maxWorkItemDimensions.
	The minimum value is (1, 1, 1).
	End Rem
	Field maxWorkItemSizes:Int[]
	Rem
	bbdoc: Maximum number of work-items in a work-group executing a kernel using the data parallel execution model.
	End Rem
	Field maxWorkGroupSize:Int
	Rem
	bbdoc: Maximum configured clock frequency of the device in MHz.
	End Rem
	Field maxClockFrequency:Int
	Rem
	bbdoc: Max size of memory object allocation in bytes.
	about: The minimum value is max (1/4th of #globalMemSize , 128*1024*1024)
	End Rem
	Field maxMemAllocSize:Long
	Rem
	bbdoc: Is True if images are supported by the OpenCL device and False otherwise.
	End Rem
	Field imageSupport:Int
	Rem
	bbdoc: Max number of simultaneous image objects that can be read by a kernel.
	about: The minimum value is 128 if #imageSupport is True.
	End Rem
	Field maxReadImageArgs:Int
	Rem
	bbdoc: Max number of simultaneous image objects that can be written to by a kernel.
	about: The minimum value is 8 if #imageSupport is True.
	End Rem
	Field maxWriteImageArgs:Int
	Rem
	bbdoc: Max width of 2D image in pixels.
	about: The minimum value is 8192 if #imageSupport is True.
	End Rem
	Field image2dMaxWidth:Int
	Rem
	bbdoc: Max height of 2D image in pixels.
	about: The minimum value is 8192 if #imageSupport is True.
	End Rem
	Field image2dMaxHeight:Int
	Rem
	bbdoc: Max width of 3D image in pixels.
	about: The minimum value is 2048 if #imageSupport is True.
	End Rem
	Field image3dMaxWidth:Int
	Rem
	bbdoc: Max height of 3D image in pixels.
	about: The minimum value is 2048 if #imageSupport is True.
	End Rem
	Field image3dMaxHeight:Int
	Rem
	bbdoc: Max depth of 3D image in pixels.
	about: The minimum value is 2048 if #imageSupport is True.
	End Rem
	Field image3dMaxDepth:Int
	Rem
	bbdoc: Maximum number of samplers that can be used in a kernel.
	about: Refer to section 6.11.8 for a detailed description on samplers. The minimum value is 16 if #imageSupport is True.
	End Rem
	Field maxSamplers:Int
	Rem
	bbdoc: Max size in bytes of the arguments that can be passed to a kernel.
	about: The minimum value is 256.
	End Rem
	Field maxParameterSize:Int
	Rem
	bbdoc: Size of global memory cache in bytes.
	End Rem
	Field globalMemCacheSize:Long
	Rem
	bbdoc: Size of global device memory in bytes.
	End Rem
	Field globalMemSize:Long
	Rem
	bbdoc: Max size in bytes of a constant buffer allocation.
	about: The minimum value is 64 KB.
	End Rem
	Field maxConstantBufferSize:Long
	Rem
	bbdoc: Max number of arguments declared with the __constant qualifier in a kernel.
	about: The minimum value is 8.
	End Rem
	Field maxConstantArgs:Int
	Rem
	bbdoc: Size of local memory arena in bytes.
	about: The minimum value is 16 KB.
	End Rem
	Field localMemSize:Int
	Rem
	bbdoc: Is True if the device implements error correction for the memories, caches, registers etc. in the device.
	about: Is False if the device does not implement error correction. This can be a requirement for certain clients of OpenCL.
	End Rem
	Field errorCorrectionSupport:Int
	Rem
	bbdoc: Describes the resolution of device timer.
	about: This is measured in nanoseconds.
	End Rem
	Field profilingTimerResolution:Int
	Rem
	bbdoc: Is True if the OpenCL device is a little endian device and False otherwise.
	End Rem
	Field endianLittle:Int
	Rem
	bbdoc: OpenCL profile.
	about: Returns the profile name supported by the device. The profile name returned can be one of the following strings:
	<ul>
	<li>FULL_PROFILE - if the device supports the OpenCL specification (functionality defined as part of the core specification and
	does not require any extensions to be supported).</li>
	<li>EMBEDDED_PROFILE - if the device supports the OpenCL embedded profile.</li>
	</ul>
	End Rem
	Field profile:String
	Rem
	bbdoc: Returns a space separated list of extension names (the extension names themselves do not contain any spaces).
	about: The list of extension names returned currently can include one or more of the following approved extension names:
	<ul>
	<li>cl_khr_fp64</li>
	<li>cl_khr_select_fprounding_mode</li>
	<li>cl_khr_global_int32_base_atomics</li>
	<li>cl_khr_global_int32_extended_atomics</li>
	<li>cl_khr_local_int32_base_atomics</li>
	<li>cl_khr_local_int32_extended_atomics</li>
	<li>cl_khr_int64_base_atomics</li>
	<li>cl_khr_int64_extended_atomics</li>
	<li>cl_khr_3d_image_writes</li>
	<li>cl_khr_byte_addressable_store</li>
	<li>cl_khr_fp16</li>
	<li>cl_khr_gl_sharing</li>
	</ul>
	End Rem
	Field extensions:String
	Rem
	bbdoc: The default compute device address space size specified as an unsigned integer value in bits.
	about: Currently supported values are 32 or 64 bits.
	End Rem
	Field deviceAddressBits:Int
	Rem
	bbdoc: Is True if the device is available and False if the device is not available.
	End Rem
	Field deviceAvailable:Int
	Rem
	bbdoc: Describes single precision floating-point capability of the device.
	about: This is a bit-field that describes one or more of the following values : #CL_FP_DENORM, #CL_FP_INF_NAN, #CL_FP_ROUND_TO_NEAREST,
	#CL_FP_ROUND_TO_ZERO, #CL_FP_ROUND_TO_INF, and #CP_FP_FMA.
	<p>
	The mandated minimum floating-point capability is  #CL_FP_ROUND_TO_NEAREST | #CL_FP_INF_NAN.
	</p>
	End Rem
	Field singleFPConfig:Int

	Function _create:TCLDeviceInfo(vendorName:String, deviceName:String, driverVersion:String, deviceVersion:String, ..
			maxComputeUnits:Int, maxWorkItemDimensions:Int, maxWorkItemSizes:Int[], maxWorkGroupSize:Int, maxClockFrequency:Int, ..
			maxMemAllocSize:Long, imageSupport:Int, maxReadImageArgs:Int, maxWriteImageArgs:Int, image2dMaxWidth:Int, ..
			image2dMaxHeight:Int, image3dMaxWidth:Int, image3dMaxHeight:Int, image3dMaxDepth:Int, maxSamplers:Int, maxParameterSize:Int, ..
			globalMemCacheSize:Long, globalMemSize:Long, maxConstantBufferSize:Long, maxConstantArgs:Int, localMemSize:Int, ..
			errorCorrectionSupport:Int, profilingTimerResolution:Int, endianLittle:Int, profile:String, extensions:String, ..
			deviceAddressBits:Int, deviceAvailable:Int, singleFPConfig:Int) { nomangle }

		Local this:TCLDeviceInfo = New TCLDeviceInfo
		this.vendorName = vendorName
		this.deviceName = deviceName
		this.driverVersion = driverVersion
		this.deviceVersion = deviceVersion
		this.maxComputeUnits = maxComputeUnits
		this.maxWorkItemDimensions = maxWorkItemDimensions
		this.maxWorkItemSizes = maxWorkItemSizes
		this.maxWorkGroupSize = maxWorkGroupSize
		this.maxClockFrequency = maxClockFrequency
		this.maxMemAllocSize = maxMemAllocSize
		this.imageSupport = imageSupport
		this.maxReadImageArgs = maxReadImageArgs
		this.maxWriteImageArgs = maxWriteImageArgs
		this.image2dMaxWidth = image2dMaxWidth
		this.image2dMaxHeight = image2dMaxHeight
		this.image3dMaxWidth = image3dMaxWidth
		this.image3dMaxHeight = image3dMaxHeight
		this.image3dMaxDepth = image3dMaxDepth
		this.maxSamplers = maxSamplers
		this.maxParameterSize = maxParameterSize
		this.globalMemCacheSize = globalMemCacheSize
		this.globalMemSize = globalMemSize
		this.maxConstantBufferSize = maxConstantBufferSize
		this.maxConstantArgs = maxConstantArgs
		this.localMemSize = localMemSize
		this.errorCorrectionSupport = errorCorrectionSupport
		this.profilingTimerResolution = profilingTimerResolution
		this.endianLittle = endianLittle
		this.profile = profile
		this.extensions = extensions
		this.deviceAddressBits = deviceAddressBits
		this.deviceAvailable = deviceAvailable
		this.singleFPConfig = singleFPConfig

		Return this
	End Function	

End Type


Rem
bbdoc: A kernel is a function declared in a program.
about: A kernel is identified by the __kernel qualifier applied to any function in a program. A kernel object encapsulates the specific __kernel
function declared in a program and the argument values to be used when executing this __kernel function.
End Rem
Type TCLKernel

	Field kernelPtr:Byte Ptr
	Field program:TCLProgram
	
	Rem
	bbdoc: Creates a kernel object.
	about: Parameters:
	<ul>
	<li><b>name</b> : A function name in the program declared with the __kernel qualifier.</li>
	<li><b>program</b> : A program object with a successfully built executable.</li>
	</ul>
	<p>
	A kernel is a function declared in a program. A kernel is identified by the __kernel qualifier applied to any
	function in a program. A kernel object encapsulates the specific __kernel function declared in a program and the
	argument values to be used when executing this __kernel function.
	</p>
	End Rem
	Function Load:TCLKernel(name:String, program:TCLProgram)
		Local this:TCLKernel = New TCLKernel
		this.kernelPtr = bmx_ocl_kernel_create(this, name, program.programPtr)
		this.program = program
		Return this
	End Function

	Rem
	bbdoc: Sets the argument value as a TCLMem object for a specific argument of a kernel.
	returns: CL_SUCCESS if the method is executed successfully. See below for more error values.
	about: 
	End Rem
	Method SetArg:Int(index:Int, mem:TCLMem)
		If TCLBuffer(mem)
			Return bmx_ocl_kernel_setargbuffer(kernelPtr, index, mem.memPtr)
		Else
			'Return bmx_ocl_kernel_setargimage(kernelPtr, index, buffer.memPtr)
		End If
	End Method
	
	Rem
	bbdoc: Sets the argument value as an int for a specific argument of a kernel.
	returns: CL_SUCCESS if the method is executed successfully. See below for more error values.
	about: 
	End Rem
	Method SetArgInt:Int(index:Int, value:Int)
		Return bmx_ocl_kernel_setargint(kernelPtr, index, Varptr value)
	End Method
	
	Rem
	bbdoc: Sets the argument value as a float for a specific argument of a kernel.
	returns: CL_SUCCESS if the method is executed successfully. See below for more error values.
	End Rem
	Method SetArgFloat:Int(index:Int, value:Float)
		Return bmx_ocl_kernel_setargfloat(kernelPtr, index, Varptr value)
	End Method
	
	Rem
	bbdoc: Sets the argument value as a long for a specific argument of a kernel.
	returns: CL_SUCCESS if the method is executed successfully. See below for more error values.
	End Rem
	Method SetArgLong:Int(index:Int, value:Long)
		Return bmx_ocl_kernel_setarglong(kernelPtr, index, Varptr value)
	End Method
	
	Rem
	bbdoc: Enqueues a command to execute a kernel on a device, based on a single work dimension.
	returns: CL_SUCCESS if the kernel execution was successfully queued. See below for more error values.
	about: Parameters:
	<ul>
	<li><b>workDim</b> : The number of dimensions used to specify the global work-items and work-items in the work-group. @workDim
	must be greater than zero and less than or equal to three.</li>
	<li><b>globalWorkSize</b> : Points to an an unsigned value that describe the number of global work-items in that will execute
	the kernel function.<br>
	The values specified in @globalWorkSize cannot exceed the range given by the sizeof(size_t) for the device on which the kernel
	execution will be enqueued. The sizeof(size_t) for a device can be determined using CL_DEVICE_ADDRESS_BITS in
	the table of OpenCL Device Queries for CLDevice.GetInfo. If, for example, CL_DEVICE_ADDRESS_BITS = 32, i.e. the
	device uses a 32-bit address space, size_t is a 32-bit unsigned integer and global_work_size values must be in the range 1 .. 2^32 - 1.
	Values outside this range return a CL_OUT_OF_RESOURCES error.</li>
	<li><b>localWorkSize</b> : A value that describes the number of work-items that make up a work-group (also referred to as the size of
	the work-group) that will execute the kernel. The total number of work-items in the work-group must be less than or equal to the
	CL_DEVICE_MAX_WORK_GROUP_SIZE value specified in table of OpenCL Device Queries for GetInfo and the number of work-items specified
	in @localWorkSize must be less than or equal to the corresponding values specified by CL_DEVICE_MAX_WORK_ITEM_SIZES. The
	explicitly specified @localWorkSize will be used to determine how to break the global work-items specified by @globalWorkSize
	into appropriate work-group instances. If @localWorkSize is specified, the values specified in @globalWorkSize must be evenly
	divisable by the corresponding values specified in @localWorkS.<br>
	The work-group size to be used for kernel can also be specified in the program source using the
	<tt>__attribute__((reqd_work_group_size(X, Y, Z)))</tt> qualifier. In this case the size of work group specified by @localWorkSize
	must match the value specified by the <tt>reqd_work_group_size __attribute__</tt> qualifier.<br>
	@localWorkSize can also be a zero value in which case the OpenCL implementation will determine how to be break the global
	work-items into appropriate work-group instances.</li>
	</ul>
	<p>
	<b>Errors</b>
	<ul>
	<li>CL_INVALID_PROGRAM_EXECUTABLE if there is no successfully built program executable available for device associated with command_queue.</li>
	<li>CL_INVALID_COMMAND_QUEUE if command_queue is not a valid command-queue.</li>
	<li>CL_INVALID_KERNEL if kernel is not a valid kernel object.</li>
	<li>CL_INVALID_CONTEXT if context associated with command_queue and kernel is not the same or if the context associated
	with command_queue and events in event_wait_list are not the same.</li>
	<li>CL_INVALID_KERNEL_ARGS if the kernel argument values have not been specified.</li>
	<li>CL_INVALID_WORK_DIMENSION if work_dim is not a valid value (i.e. a value between 1 and 3).</li>
	<li>CL_INVALID_WORK_GROUP_SIZE if local_work_size is specified and number of work-items specified by @globalWorkSize is not evenly
	divisable by size of work-group given by @localWorkSize or does not match the work-group size specified for kernel using
	the <tt>__attribute__((reqd_work_group_size(X, Y, Z)))</tt> qualifier in program source.</li>
	<li>CL_INVALID_WORK_GROUP_SIZE if @localWorkSize is specified and the total number of work-items in the work-group is greater than
	the value specified by CL_DEVICE_MAX_WORK_GROUP_SIZE in the table of OpenCL Device Queries for GetInfo.</li>
	<li>CL_INVALID_WORK_GROUP_SIZE if @localWorkSize is zero and the <tt>__attribute__((reqd_work_group_size(X, Y, Z)))</tt> qualifier
	is used to declare the work-group size for kernel in the program source.</li>
	<li>CL_INVALID_WORK_ITEM_SIZE if the number of work-items specified in @localWorkSize is greater than the corresponding values
	specified by CL_DEVICE_MAX_WORK_ITEM_SIZES.</li>
	<li>CL_OUT_OF_RESOURCES if there is a failure to queue the execution instance of kernel on the command-queue because of
	insufficient resources needed to execute the kernel. For example, the explicitly specified @localWorkSize causes a
	failure to execute the kernel because of insufficient resources such as registers or local memory. Another example would
	be the number of read-only image args used in kernel exceed the CL_DEVICE_MAX_READ_IMAGE_ARGS value for device or the number
	of write-only image args used in kernel exceed the CL_DEVICE_MAX_WRITE_IMAGE_ARGS value for device or the number of samplers
	used in kernel exceed CL_DEVICE_MAX_SAMPLERS for device.</li>
	<li>CL_MEM_OBJECT_ALLOCATION_FAILURE if there is a failure to allocate memory for data store associated with image or buffer
	objects specified as arguments to kernel.</li>
	<li>CL_OUT_OF_HOST_MEMORY if there is a failure to allocate resources required by the OpenCL implementation on the host.</li>
	</ul>
	</p>
	End Rem
	Method Execute:Int(globalWorkSize:Int, localWorkSize:Int = 0)
		Return bmx_ocl_kernel_execute(kernelPtr, globalWorkSize, localWorkSize)
	End Method

	Rem
	bbdoc: Enqueues a command to execute a kernel on a device.
	about: Parameters:
	<ul>
	<li><b>workDim</b> : The number of dimensions used to specify the global work-items and work-items in the work-group. @workDim
	must be greater than zero and less than or equal to three.</li>
	<li><b>globalWorkSize</b> : Points to an array of @workDim unsigned values that describe the number of global work-items in
	@workDim dimensions that will execute the kernel function. The total number of global work-items is computed as
	<tt>globalWorkSize[0] *...* globalWorkSize[work_dim - 1]</tt>.<br>
	The values specified in @globalWorkSize cannot exceed the range given by the sizeof(size_t) for the device on which the kernel
	execution will be enqueued. The sizeof(size_t) for a device can be determined using CL_DEVICE_ADDRESS_BITS in
	the table of OpenCL Device Queries for CLDevice.GetInfo. If, for example, CL_DEVICE_ADDRESS_BITS = 32, i.e. the
	device uses a 32-bit address space, size_t is a 32-bit unsigned integer and global_work_size values must be in the range 1 .. 2^32 - 1.
	Values outside this range return a CL_OUT_OF_RESOURCES error.</li>
	<li><b>localWorkSize</b> : xxxxxxxxxxxxxxxxx.</li>
	</ul>
	End Rem
	Method ExecuteDim:Int(workDim:Int, globalWorkSize:Int[], localWorkSize:Int[] = Null)
		Return bmx_ocl_kernel_executedim(kernelPtr, workDim, globalWorkSize, localWorkSize)
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Type TCLProgram

	Field programPtr:Byte Ptr
	Field platform:TCLPlatform

	' private
	Function Load:TCLProgram(platform:TCLPlatform, Text:String)
		Local this:TCLProgram = New TCLProgram
		this.programPtr = bmx_ocl_program_create(this, platform.platformPtr, Text)
		this.platform = platform
		
		Return this
	End Function
	
	Rem
	bbdoc: 
	End Rem
	Method LoadKernel:TCLKernel(name:String)
		Return TCLKernel.Load(name, Self)
	End Method

	Method Delete()
		If programPtr Then
			bmx_ocl_program_free(programPtr)
			programPtr = Null
		End If
	End Method
	
End Type

Type TCLMem

	Field memPtr:Byte Ptr
	
End Type

Rem
bbdoc: 
End Rem
Type TCLBuffer Extends TCLMem

	' private
	Function Create:TCLBuffer(platform:TCLPlatform, flags:Int, size:Int, data:Byte Ptr)
		Local this:TCLBuffer = New TCLBuffer
		
		If data Then
			this.memPtr = bmx_ocl_membuff_create(this, platform.platformPtr, flags, size, data)
		Else
			this.memPtr = bmx_ocl_membuff_create(this, platform.platformPtr, flags, size, Null)
		End If
		
		Return this
	End Function

	Rem
	bbdoc: Enqueues commands to write to the buffer object from host memory.
	End Rem
	Method Write:Int(size:Int, data:Byte Ptr, blockingWrite:Int = True)
		Return bmx_ocl_membuff_enqueuewrite(memPtr, blockingWrite, size, data)
	End Method
	
	Rem
	bbdoc: Enqueues commands to read from the buffer object to host memory.
	End Rem
	Method Read:Int(size:Int, data:Byte Ptr, blockingRead:Int = True)
		Return bmx_ocl_membuff_enqueueread(memPtr, blockingRead, size, data)
	End Method
	
	Rem
	bbdoc: Enqueues a command to copy the buffer object to another buffer object.
	End Rem
	Method Copy:Int(dest:TCLBuffer, offset:Int, destOffset:Int, size:Int)
		Return bmx_ocl_membuff_enqueuecopy(memPtr, dest.memPtr, offset, destOffset, size)
	End Method
	
	Rem
	bbdoc: TODO 
	End Rem
	Method CopyToImage:Int(dest:TCLImage, offset:Int, destOrigin:Int[], destregion:Int[])
	' TODO
	End Method
	
End Type

Rem
bbdoc: 
End Rem
Type TCLImage Extends TCLMem

	' private
	Function Create2D:TCLImage(platform:TCLPlatform, flags:Int, channelOrder:Int, imageType:Int, width:Int, height:Int, rowPitch:Int, hostPtr:Byte Ptr)
		Local this:TCLImage = New TCLImage
		
		If hostPtr Then
			this.memPtr = bmx_ocl_memimage_create2d(this, platform.platformPtr, flags, channelOrder, imageType, width, height, rowPitch, hostPtr)
		Else
			this.memPtr = bmx_ocl_memimage_create2d(this, platform.platformPtr, flags, channelOrder, imageType, width, height, rowPitch, Null)
		End If
		
		Return this
	End Function

	' private
	Function Create3D:TCLImage(platform:TCLPlatform, flags:Int, channelOrder:Int, imageType:Int, width:Int, height:Int, depth:Int, rowPitch:Int, slicePitch:Int, hostPtr:Byte Ptr)
		Local this:TCLImage = New TCLImage
		
		If hostPtr Then
			this.memPtr = bmx_ocl_memimage_create3d(this, platform.platformPtr, flags, channelOrder, imageType, width, height, depth, rowPitch, slicePitch, hostPtr)
		Else
			this.memPtr = bmx_ocl_memimage_create3d(this, platform.platformPtr, flags, channelOrder, imageType, width, height, depth, rowPitch, slicePitch, Null)
		End If
		
		Return this
	End Function

	Rem
	bbdoc: 
	End Rem
	Method Read:Int(blockingRead:Int, originX:Int, originY:Int, originZ:Int = 0, regionX:Int, regionY:Int, regionZ:Int = 1, rowPitch:Int, slicePitch:Int = 0, data:Byte Ptr)
		Return bmx_ocl_memimage_enqueueread(memPtr, blockingRead, originX, originY, originZ, regionX, regionY, regionZ, rowPitch, slicePitch, data)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method Write:Int(blockingWrite:Int, originX:Int, originY:Int, originZ:Int = 0, regionX:Int, regionY:Int, regionZ:Int = 1, rowPitch:Int, slicePitch:Int = 0, data:Byte Ptr)
		Return bmx_ocl_memimage_enqueuewrite(memPtr, blockingWrite, originX, originY, originZ, regionX, regionY, regionZ, rowPitch, slicePitch, data)
	End Method
	
	Method Copy:Int(dest:TCLImage, originX:Int, originY:Int, originZ:Int = 0, destOriginX:Int, destOriginY:Int, destOriginZ:Int = 0, regionX:Int, regionY:Int, regionZ:Int = 1, rowPitch:Int, slicePitch:Int = 0)
	End Method
	
	Method CopyToBuffer:Int()
	End Method

End Type



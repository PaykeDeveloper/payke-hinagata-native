const productMode = bool.fromEnvironment('dart.vm.product');
const debugPrintSize = !productMode && bool.fromEnvironment('DEBUG_PAINT_SIZE');
const backendBaseUrl = String.fromEnvironment('BACKEND_ORIGIN');

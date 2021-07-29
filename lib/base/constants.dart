const productMode = bool.fromEnvironment('dart.vm.product');
const debugPrintSize = !productMode && bool.fromEnvironment('DEBUG_PAINT_SIZE');
const _backendOrigin = String.fromEnvironment('BACKEND_ORIGIN');
final backendBaseUrl = _backendOrigin.isNotEmpty ? '$_backendOrigin/' : '';

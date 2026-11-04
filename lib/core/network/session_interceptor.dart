import 'package:connectrpc/connect.dart';

/// Adds `authorization: Bearer <token>` to every call and reports
/// `unauthenticated` replies, which means the server wants a new `Unlock`.
Interceptor sessionInterceptor({
  required String? Function() token,
  required void Function() onUnauthenticated,
}) {
  return <I extends Object, O extends Object>(AnyFn<I, O> next) =>
      (Request<I, O> req) async {
        final t = token();
        if (t != null && t.isNotEmpty) {
          req.headers.set('authorization', ['Bearer $t']);
        }
        try {
          return await next(req);
        } on ConnectException catch (e) {
          if (e.code == Code.unauthenticated) onUnauthenticated();
          rethrow;
        }
      };
}

import '../models/models.dart';
import '../network/network.dart';
import '../utils/utils.dart';

class MemberApi {
  static const _apiVersion = 'v1';

  Future<Token> createAccount(CreateMemberRequest request) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () => Token(
        accessToken: 'accessToken',
        tokenType: 'tokenType',
        expiresAt: 71237012830128,
        refreshToken: 'expiresAt',
      ),
    );
  }
}

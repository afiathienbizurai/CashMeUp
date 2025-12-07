// lib/features/auth/dummy_users.dart

class DummyUsers {
  static final users = [
    {
      "username": "professor",
      "email": "prof@example.com",
      "password": "123456"
    },
    {
      "username": "gadget",
      "email": "gadget@example.com",
      "password": "password"
    }
  ];

  static Map<String, String>? login(String identifier, String password) {
    return users.firstWhere(
      (u) =>
          (u["username"] == identifier || u["email"] == identifier) &&
          u["password"] == password,
      orElse: () => {},
    );
  }
}

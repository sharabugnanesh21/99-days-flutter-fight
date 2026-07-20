class UserState {
  final bool isLoading;
  final List<String>? users;
  final String? error;

  UserState({
    this.isLoading = false,
    this.users,
    this.error,
  });

  UserState copyWith({
    bool? isLoading,
    List<String>? users,
    String? error,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      error: error ?? this.error,
    );
  }
}

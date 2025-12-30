/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:code_butler_new_client/src/protocol/review_notification.dart'
    as _i5;
import 'package:code_butler_new_client/src/protocol/pull_request.dart' as _i6;
import 'package:code_butler_new_client/src/protocol/repository.dart' as _i7;
import 'package:code_butler_new_client/src/protocol/review_session.dart' as _i8;
import 'package:code_butler_new_client/src/protocol/agent_finding.dart' as _i9;
import 'package:code_butler_new_client/src/protocol/greetings/greeting.dart'
    as _i10;
import 'protocol.dart' as _i11;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Health check endpoint
/// {@category Endpoint}
class EndpointHealthCheck extends _i2.EndpointRef {
  EndpointHealthCheck(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'healthCheck';

  /// Comprehensive health check
  _i3.Future<Map<String, dynamic>> healthCheck() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'healthCheck',
        'healthCheck',
        {},
      );
}

/// Metrics endpoint for analytics and monitoring
/// {@category Endpoint}
class EndpointMetrics extends _i2.EndpointRef {
  EndpointMetrics(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'metrics';

  /// Gets repository health score
  _i3.Future<Map<String, dynamic>> getRepositoryHealth(int repositoryId) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'metrics',
        'getRepositoryHealth',
        {'repositoryId': repositoryId},
      );

  /// Gets trends data
  _i3.Future<Map<String, dynamic>> getTrends(String period) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'metrics',
        'getTrends',
        {'period': period},
      );

  /// Gets most problematic files
  _i3.Future<List<Map<String, dynamic>>> getMostProblematicFiles(
    int repositoryId,
  ) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'metrics',
    'getMostProblematicFiles',
    {'repositoryId': repositoryId},
  );

  /// Gets agent effectiveness metrics
  _i3.Future<Map<String, dynamic>> getAgentEffectiveness() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'metrics',
        'getAgentEffectiveness',
        {},
      );

  /// Gets review statistics
  _i3.Future<Map<String, dynamic>> getReviewStats() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'metrics',
        'getReviewStats',
        {},
      );
}

/// Notification endpoint for user notifications
/// {@category Endpoint}
class EndpointNotification extends _i2.EndpointRef {
  EndpointNotification(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// Gets notifications for a user
  _i3.Future<List<_i5.ReviewNotification>> getNotifications(String userId) =>
      caller.callServerEndpoint<List<_i5.ReviewNotification>>(
        'notification',
        'getNotifications',
        {'userId': userId},
      );

  /// Marks notification as read
  _i3.Future<void> markAsRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'notification',
        'markAsRead',
        {'notificationId': notificationId},
      );

  /// Gets unread notification count
  _i3.Future<int> getUnreadCount(String userId) =>
      caller.callServerEndpoint<int>(
        'notification',
        'getUnreadCount',
        {'userId': userId},
      );
}

/// {@category Endpoint}
class EndpointPullRequest extends _i2.EndpointRef {
  EndpointPullRequest(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'pullRequest';

  /// Creates a new pull request
  _i3.Future<_i6.PullRequest> createPullRequest(
    int repositoryId,
    int prNumber,
    String title,
    String baseBranch,
    String headBranch,
    int filesChanged,
  ) => caller.callServerEndpoint<_i6.PullRequest>(
    'pullRequest',
    'createPullRequest',
    {
      'repositoryId': repositoryId,
      'prNumber': prNumber,
      'title': title,
      'baseBranch': baseBranch,
      'headBranch': headBranch,
      'filesChanged': filesChanged,
    },
  );

  /// Lists all pull requests for a repository, ordered by PR number descending
  _i3.Future<List<_i6.PullRequest>> listPullRequests(int repositoryId) =>
      caller.callServerEndpoint<List<_i6.PullRequest>>(
        'pullRequest',
        'listPullRequests',
        {'repositoryId': repositoryId},
      );

  /// Gets a pull request by repository ID and PR number
  _i3.Future<_i6.PullRequest?> getPullRequest(
    int repositoryId,
    int prNumber,
  ) => caller.callServerEndpoint<_i6.PullRequest?>(
    'pullRequest',
    'getPullRequest',
    {
      'repositoryId': repositoryId,
      'prNumber': prNumber,
    },
  );
}

/// {@category Endpoint}
class EndpointRepository extends _i2.EndpointRef {
  EndpointRepository(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'repository';

  /// Creates a new repository in the database
  _i3.Future<_i7.Repository> createRepository(
    String name,
    String url,
    String owner,
    String defaultBranch,
  ) => caller.callServerEndpoint<_i7.Repository>(
    'repository',
    'createRepository',
    {
      'name': name,
      'url': url,
      'owner': owner,
      'defaultBranch': defaultBranch,
    },
  );

  /// Lists all repositories ordered by name
  _i3.Future<List<_i7.Repository>> listRepositories() =>
      caller.callServerEndpoint<List<_i7.Repository>>(
        'repository',
        'listRepositories',
        {},
      );

  /// Gets a repository by its URL
  _i3.Future<_i7.Repository?> getRepositoryByUrl(String url) =>
      caller.callServerEndpoint<_i7.Repository?>(
        'repository',
        'getRepositoryByUrl',
        {'url': url},
      );
}

/// {@category Endpoint}
class EndpointReview extends _i2.EndpointRef {
  EndpointReview(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'review';

  /// Starts a new review session for a pull request
  /// Spawns async background task to run agent processing
  _i3.Future<_i8.ReviewSession> startReview(int pullRequestId) =>
      caller.callServerEndpoint<_i8.ReviewSession>(
        'review',
        'startReview',
        {'pullRequestId': pullRequestId},
      );

  /// Gets the current status of a review session
  _i3.Future<_i8.ReviewSession?> getReviewStatus(int reviewSessionId) =>
      caller.callServerEndpoint<_i8.ReviewSession?>(
        'review',
        'getReviewStatus',
        {'reviewSessionId': reviewSessionId},
      );

  /// Gets all findings for a pull request, optionally filtered by severity
  _i3.Future<List<_i9.AgentFinding>> getFindings(
    int pullRequestId, {
    String? severity,
  }) => caller.callServerEndpoint<List<_i9.AgentFinding>>(
    'review',
    'getFindings',
    {
      'pullRequestId': pullRequestId,
      'severity': severity,
    },
  );

  /// Streams review progress updates, polling every 2 seconds
  _i3.Stream<String> watchReviewProgress(int reviewSessionId) =>
      caller.callStreamingServerEndpoint<_i3.Stream<String>, String>(
        'review',
        'watchReviewProgress',
        {'reviewSessionId': reviewSessionId},
        {},
      );
}

/// Webhook endpoint for GitHub event handling
/// {@category Endpoint}
class EndpointWebhook extends _i2.EndpointRef {
  EndpointWebhook(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'webhook';

  /// Handles pull request events from GitHub
  _i3.Future<void> handlePullRequest(
    Map<String, dynamic> payload,
    String? signature,
  ) => caller.callServerEndpoint<void>(
    'webhook',
    'handlePullRequest',
    {
      'payload': payload,
      'signature': signature,
    },
  );

  /// Handles push events from GitHub
  _i3.Future<void> handlePush(
    Map<String, dynamic> payload,
    String? signature,
  ) => caller.callServerEndpoint<void>(
    'webhook',
    'handlePush',
    {
      'payload': payload,
      'signature': signature,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i10.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i10.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i11.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    healthCheck = EndpointHealthCheck(this);
    metrics = EndpointMetrics(this);
    notification = EndpointNotification(this);
    pullRequest = EndpointPullRequest(this);
    repository = EndpointRepository(this);
    review = EndpointReview(this);
    webhook = EndpointWebhook(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointHealthCheck healthCheck;

  late final EndpointMetrics metrics;

  late final EndpointNotification notification;

  late final EndpointPullRequest pullRequest;

  late final EndpointRepository repository;

  late final EndpointReview review;

  late final EndpointWebhook webhook;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'healthCheck': healthCheck,
    'metrics': metrics,
    'notification': notification,
    'pullRequest': pullRequest,
    'repository': repository,
    'review': review,
    'webhook': webhook,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}

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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/health_check_endpoint.dart' as _i4;
import '../endpoints/metrics_endpoint.dart' as _i5;
import '../endpoints/notification_endpoint.dart' as _i6;
import '../endpoints/pull_request_endpoint.dart' as _i7;
import '../endpoints/repository_endpoint.dart' as _i8;
import '../endpoints/review_endpoint.dart' as _i9;
import '../endpoints/webhook_endpoint.dart' as _i10;
import '../greetings/greeting_endpoint.dart' as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i12;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'healthCheck': _i4.HealthCheckEndpoint()
        ..initialize(
          server,
          'healthCheck',
          null,
        ),
      'metrics': _i5.MetricsEndpoint()
        ..initialize(
          server,
          'metrics',
          null,
        ),
      'notification': _i6.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'pullRequest': _i7.PullRequestEndpoint()
        ..initialize(
          server,
          'pullRequest',
          null,
        ),
      'repository': _i8.RepositoryEndpoint()
        ..initialize(
          server,
          'repository',
          null,
        ),
      'review': _i9.ReviewEndpoint()
        ..initialize(
          server,
          'review',
          null,
        ),
      'webhook': _i10.WebhookEndpoint()
        ..initialize(
          server,
          'webhook',
          null,
        ),
      'greeting': _i11.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['healthCheck'] = _i1.EndpointConnector(
      name: 'healthCheck',
      endpoint: endpoints['healthCheck']!,
      methodConnectors: {
        'healthCheck': _i1.MethodConnector(
          name: 'healthCheck',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['healthCheck'] as _i4.HealthCheckEndpoint)
                  .healthCheck(session),
        ),
      },
    );
    connectors['metrics'] = _i1.EndpointConnector(
      name: 'metrics',
      endpoint: endpoints['metrics']!,
      methodConnectors: {
        'getRepositoryHealth': _i1.MethodConnector(
          name: 'getRepositoryHealth',
          params: {
            'repositoryId': _i1.ParameterDescription(
              name: 'repositoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['metrics'] as _i5.MetricsEndpoint)
                  .getRepositoryHealth(
                    session,
                    params['repositoryId'],
                  ),
        ),
        'getTrends': _i1.MethodConnector(
          name: 'getTrends',
          params: {
            'period': _i1.ParameterDescription(
              name: 'period',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['metrics'] as _i5.MetricsEndpoint).getTrends(
                    session,
                    params['period'],
                  ),
        ),
        'getMostProblematicFiles': _i1.MethodConnector(
          name: 'getMostProblematicFiles',
          params: {
            'repositoryId': _i1.ParameterDescription(
              name: 'repositoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['metrics'] as _i5.MetricsEndpoint)
                  .getMostProblematicFiles(
                    session,
                    params['repositoryId'],
                  ),
        ),
        'getAgentEffectiveness': _i1.MethodConnector(
          name: 'getAgentEffectiveness',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['metrics'] as _i5.MetricsEndpoint)
                  .getAgentEffectiveness(session),
        ),
        'getReviewStats': _i1.MethodConnector(
          name: 'getReviewStats',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['metrics'] as _i5.MetricsEndpoint)
                  .getReviewStats(session),
        ),
      },
    );
    connectors['notification'] = _i1.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'getNotifications': _i1.MethodConnector(
          name: 'getNotifications',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i6.NotificationEndpoint)
                  .getNotifications(
                    session,
                    params['userId'],
                  ),
        ),
        'markAsRead': _i1.MethodConnector(
          name: 'markAsRead',
          params: {
            'notificationId': _i1.ParameterDescription(
              name: 'notificationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i6.NotificationEndpoint)
                  .markAsRead(
                    session,
                    params['notificationId'],
                  ),
        ),
        'getUnreadCount': _i1.MethodConnector(
          name: 'getUnreadCount',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i6.NotificationEndpoint)
                  .getUnreadCount(
                    session,
                    params['userId'],
                  ),
        ),
      },
    );
    connectors['pullRequest'] = _i1.EndpointConnector(
      name: 'pullRequest',
      endpoint: endpoints['pullRequest']!,
      methodConnectors: {
        'createPullRequest': _i1.MethodConnector(
          name: 'createPullRequest',
          params: {
            'repositoryId': _i1.ParameterDescription(
              name: 'repositoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'prNumber': _i1.ParameterDescription(
              name: 'prNumber',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'baseBranch': _i1.ParameterDescription(
              name: 'baseBranch',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'headBranch': _i1.ParameterDescription(
              name: 'headBranch',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'filesChanged': _i1.ParameterDescription(
              name: 'filesChanged',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pullRequest'] as _i7.PullRequestEndpoint)
                  .createPullRequest(
                    session,
                    params['repositoryId'],
                    params['prNumber'],
                    params['title'],
                    params['baseBranch'],
                    params['headBranch'],
                    params['filesChanged'],
                  ),
        ),
        'listPullRequests': _i1.MethodConnector(
          name: 'listPullRequests',
          params: {
            'repositoryId': _i1.ParameterDescription(
              name: 'repositoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pullRequest'] as _i7.PullRequestEndpoint)
                  .listPullRequests(
                    session,
                    params['repositoryId'],
                  ),
        ),
        'getPullRequest': _i1.MethodConnector(
          name: 'getPullRequest',
          params: {
            'repositoryId': _i1.ParameterDescription(
              name: 'repositoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'prNumber': _i1.ParameterDescription(
              name: 'prNumber',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pullRequest'] as _i7.PullRequestEndpoint)
                  .getPullRequest(
                    session,
                    params['repositoryId'],
                    params['prNumber'],
                  ),
        ),
      },
    );
    connectors['repository'] = _i1.EndpointConnector(
      name: 'repository',
      endpoint: endpoints['repository']!,
      methodConnectors: {
        'createRepository': _i1.MethodConnector(
          name: 'createRepository',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'url': _i1.ParameterDescription(
              name: 'url',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'owner': _i1.ParameterDescription(
              name: 'owner',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'defaultBranch': _i1.ParameterDescription(
              name: 'defaultBranch',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i8.RepositoryEndpoint)
                  .createRepository(
                    session,
                    params['name'],
                    params['url'],
                    params['owner'],
                    params['defaultBranch'],
                  ),
        ),
        'listRepositories': _i1.MethodConnector(
          name: 'listRepositories',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i8.RepositoryEndpoint)
                  .listRepositories(session),
        ),
        'getRepositoryByUrl': _i1.MethodConnector(
          name: 'getRepositoryByUrl',
          params: {
            'url': _i1.ParameterDescription(
              name: 'url',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i8.RepositoryEndpoint)
                  .getRepositoryByUrl(
                    session,
                    params['url'],
                  ),
        ),
      },
    );
    connectors['review'] = _i1.EndpointConnector(
      name: 'review',
      endpoint: endpoints['review']!,
      methodConnectors: {
        'startReview': _i1.MethodConnector(
          name: 'startReview',
          params: {
            'pullRequestId': _i1.ParameterDescription(
              name: 'pullRequestId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['review'] as _i9.ReviewEndpoint).startReview(
                    session,
                    params['pullRequestId'],
                  ),
        ),
        'getReviewStatus': _i1.MethodConnector(
          name: 'getReviewStatus',
          params: {
            'reviewSessionId': _i1.ParameterDescription(
              name: 'reviewSessionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['review'] as _i9.ReviewEndpoint).getReviewStatus(
                    session,
                    params['reviewSessionId'],
                  ),
        ),
        'getFindings': _i1.MethodConnector(
          name: 'getFindings',
          params: {
            'pullRequestId': _i1.ParameterDescription(
              name: 'pullRequestId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'severity': _i1.ParameterDescription(
              name: 'severity',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['review'] as _i9.ReviewEndpoint).getFindings(
                    session,
                    params['pullRequestId'],
                    severity: params['severity'],
                  ),
        ),
        'watchReviewProgress': _i1.MethodStreamConnector(
          name: 'watchReviewProgress',
          params: {
            'reviewSessionId': _i1.ParameterDescription(
              name: 'reviewSessionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['review'] as _i9.ReviewEndpoint)
                  .watchReviewProgress(
                    session,
                    params['reviewSessionId'],
                  ),
        ),
      },
    );
    connectors['webhook'] = _i1.EndpointConnector(
      name: 'webhook',
      endpoint: endpoints['webhook']!,
      methodConnectors: {
        'handlePullRequest': _i1.MethodConnector(
          name: 'handlePullRequest',
          params: {
            'payload': _i1.ParameterDescription(
              name: 'payload',
              type: _i1.getType<Map<String, dynamic>>(),
              nullable: false,
            ),
            'signature': _i1.ParameterDescription(
              name: 'signature',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['webhook'] as _i10.WebhookEndpoint)
                  .handlePullRequest(
                    session,
                    params['payload'],
                    params['signature'],
                  ),
        ),
        'handlePush': _i1.MethodConnector(
          name: 'handlePush',
          params: {
            'payload': _i1.ParameterDescription(
              name: 'payload',
              type: _i1.getType<Map<String, dynamic>>(),
              nullable: false,
            ),
            'signature': _i1.ParameterDescription(
              name: 'signature',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhook'] as _i10.WebhookEndpoint).handlePush(
                    session,
                    params['payload'],
                    params['signature'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i11.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i12.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i13.Endpoints()
      ..initializeEndpoints(server);
  }
}

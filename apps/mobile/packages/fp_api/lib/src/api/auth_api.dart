//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:fp_api/src/model/inline_object.dart';
import 'package:fp_api/src/model/inline_object1.dart';
import 'package:fp_api/src/model/login_request.dart';
import 'package:fp_api/src/model/login_result.dart';
import 'package:fp_api/src/model/mfa_enrollment.dart';
import 'package:fp_api/src/model/mfa_enrollment_confirm_request.dart';
import 'package:fp_api/src/model/mfa_enrollment_confirm_result.dart';
import 'package:fp_api/src/model/mfa_proof_request.dart';
import 'package:fp_api/src/model/mfa_re_enrollment_request.dart';
import 'package:fp_api/src/model/mfa_verify_request.dart';
import 'package:fp_api/src/model/mobile_login200_response.dart';
import 'package:fp_api/src/model/mobile_login_request.dart';
import 'package:fp_api/src/model/mobile_mfa_verify_request.dart';
import 'package:fp_api/src/model/mobile_refresh_request.dart';
import 'package:fp_api/src/model/mobile_session.dart';
import 'package:fp_api/src/model/password_change_request.dart';
import 'package:fp_api/src/model/password_forgot_request.dart';
import 'package:fp_api/src/model/password_policy.dart';
import 'package:fp_api/src/model/password_reset_request.dart';
import 'package:fp_api/src/model/problem.dart';
import 'package:fp_api/src/model/rate_limited_problem.dart';
import 'package:fp_api/src/model/recovery_codes.dart';
import 'package:fp_api/src/model/service_unavailable_problem.dart';
import 'package:fp_api/src/model/session_result.dart';

class AuthApi {

  final Dio _dio;

  final Serializers _serializers;

  const AuthApi(this._dio, this._serializers);

  /// Change le mot de passe (dont le mot de passe temporaire)
  /// Session restreinte &#x60;PASSWORD_CHANGE&#x60; ou session complète. **&#x60;currentPassword&#x60;** (ux N-02, avis securite du 2026-10-12, écart ASVS 4.0.3 §2.1.6 assumé) : - session **complète** : obligatoire (absent : &#x60;VALIDATION_FAILED&#x60;, code &#x60;REQUIRED&#x60;) ; - état **&#x60;PASSWORD_CHANGE&#x60;** : non demandé et ignoré s&#39;il est envoyé. Cette exemption tient   aux conditions suivantes : (1) la session restreinte dure **10 min au plus, en absolu**,   après la vérification du mot de passe temporaire ; le rafraîchissement ne prolonge jamais   cette échéance, exposée dans &#x60;SessionResult.restrictedUntil&#x60; (au-delà :   &#x60;401 UNAUTHENTICATED&#x60; générique, retour à la connexion ; le mot de passe temporaire   reste valable jusqu&#39;à ses 72 h ou jusqu&#39;au changement réussi) ; (2) elle est à   **usage unique** : un changement réussi la consomme (nouvel identifiant de session,   nouveau &#x60;csrfToken&#x60;, état suivant) et invalide le mot de passe temporaire ; (3) elle est   liée à la **version** du mot de passe temporaire : un renvoi par l&#39;entreprise ou   l&#39;administrateur, ou l&#39;expiration des 72 h, la révoque ; (4) &#x60;X-CSRF-Token&#x60;, rate   limiting et compteur de verrouillage s&#39;appliquent (refus répétés de la politique   compris) ; (5) aucune autre route d&#39;écriture n&#39;est ouverte dans cet état (§10). &#x60;currentPassword&#x60; faux (session complète) : &#x60;400 VALIDATION_FAILED&#x60;, champ &#x60;/currentPassword&#x60; code &#x60;CURRENT_PASSWORD_INVALID&#x60; ; l&#39;échec compte dans le compteur de verrouillage (au verrouillage, toutes les sessions sont révoquées et la requête suivante reçoit &#x60;401 UNAUTHENTICATED&#x60;). Nouveau mot de passe refusé par la politique : champ &#x60;/newPassword&#x60;, code &#x60;PASSWORD_POLICY_VIOLATION&#x60;, une entrée par règle non respectée avec &#x60;params.rule&#x60; (code de &#x60;PasswordPolicyRuleCode&#x60;) et les paramètres de la règle. Succès : session renouvelée, &#x60;nextStep&#x60; suivant (§10) ; **toutes les autres sessions** et familles de jetons de rafraîchissement sont fermées (DP n° 12). Journal d&#39;audit et notification au titulaire. Jamais de mot de passe dans les journaux ni les erreurs. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [passwordChangeRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SessionResult] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SessionResult>> changePassword({ 
    required String xFlexiPayClient,
    required PasswordChangeRequest passwordChangeRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/password/change';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'csrfToken',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },{
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': '__Host-fp_at',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(PasswordChangeRequest);
      _bodyData = _serializers.serialize(passwordChangeRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SessionResult? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SessionResult),
      ) as SessionResult;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SessionResult>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Confirme l&#39;enrôlement TOTP avec un premier code
  /// Active le secret si le code est valable (&#x60;401 MFA_CODE_INVALID&#x60; sinon, échec compté dans le compteur de verrouillage ; &#x60;409 RESOURCE_STATE_CONFLICT&#x60; si aucun enrôlement n&#39;est en cours ou s&#39;il a expiré, 10 min, DP n° 23). La session devient complète (&#x60;nextStep: NONE&#x60;), identifiant de session et &#x60;csrfToken&#x60; renouvelés. Journal d&#39;audit et notification au titulaire. **Codes de secours** (SEC-A4, DP n° 10) : 10 nouveaux codes à usage unique, renvoyés **une seule fois** dans cette réponse (les anciens sont annulés) ; jamais journalisés, stockés hachés côté serveur ; le client les affiche sans les conserver. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [mfaEnrollmentConfirmRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MfaEnrollmentConfirmResult] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MfaEnrollmentConfirmResult>> confirmMfaEnrollment({ 
    required String xFlexiPayClient,
    required MfaEnrollmentConfirmRequest mfaEnrollmentConfirmRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/mfa/enroll/confirm';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'csrfToken',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },{
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': '__Host-fp_at',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(MfaEnrollmentConfirmRequest);
      _bodyData = _serializers.serialize(mfaEnrollmentConfirmRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MfaEnrollmentConfirmResult? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MfaEnrollmentConfirmResult),
      ) as MfaEnrollmentConfirmResult;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MfaEnrollmentConfirmResult>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Règles de la politique de mot de passe (aide à la saisie)
  /// Route **publique** (utile à la réinitialisation, sans session). Liste structurée de règles que le client affiche via ses clés i18n (&#x60;passwordPolicy.rule.&lt;codeEnCamelCase&gt;&#x60;), sans aucune règle codée en dur. Le serveur reste seul juge (&#x60;PASSWORD_POLICY_VIOLATION&#x60;). Valeurs en vigueur : DP n° 9 (12 à 128 caractères, aucune règle de composition, mots de passe compromis refusés par une liste locale, différent de l&#39;identifiant), comme dans l&#39;exemple. 
  ///
  /// Parameters:
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [PasswordPolicy] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<PasswordPolicy>> getPasswordPolicy({ 
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/password-policy';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    PasswordPolicy? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(PasswordPolicy),
      ) as PasswordPolicy;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<PasswordPolicy>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Connexion par identifiant (e-mail ou téléphone) et mot de passe
  /// Route **publique** (&#x60;@Public()&#x60;), contrôle exact de l&#39;en-tête &#x60;Origin&#x60; (§6, CSRF de connexion), rate limiting par IP, route et identifiant haché (§8). Voir la séquence en §10. Réponse identique (&#x60;401 INVALID_CREDENTIALS&#x60;) pour un compte inconnu, verrouillé, suspendu, un mot de passe faux ou un mot de passe temporaire expiré. Journal d&#39;audit : succès et échec (sans le mot de passe ni l&#39;identifiant en clair). 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [loginRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [LoginResult] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<LoginResult>> login({ 
    required String xFlexiPayClient,
    required LoginRequest loginRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/login';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(LoginRequest);
      _bodyData = _serializers.serialize(loginRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    LoginResult? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(LoginResult),
      ) as LoginResult;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<LoginResult>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Déconnexion (révoque la session courante)
  /// Autorisée dans tous les états de session. Révoque la session et sa famille de jetons de rafraîchissement, efface les cookies (&#x60;Max-Age&#x3D;0&#x60;). Idempotente : sans session valable, &#x60;204&#x60; quand même (cookies effacés). Journal d&#39;audit. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> logout({ 
    required String xFlexiPayClient,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/logout';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'csrfToken',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },{
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': '__Host-fp_at',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Choisir son mot de passe (première connexion) depuis l&#39;application mobile
  /// 
  ///
  /// Parameters:
  /// * [passwordChangeRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MobileSession] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MobileSession>> mobileChangePassword({ 
    required PasswordChangeRequest passwordChangeRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/mobile/auth/password/change';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'csrfToken',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },{
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': '__Host-fp_at',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(PasswordChangeRequest);
      _bodyData = _serializers.serialize(passwordChangeRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MobileSession? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MobileSession),
      ) as MobileSession;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MobileSession>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Connexion depuis une application mobile (jetons dans la réponse, pas de cookie)
  /// Mêmes règles que la connexion web (§10) : mot de passe Argon2id, compteur d&#39;échecs, MFA pour les commerçants, changement de mot de passe obligatoire à la première connexion (&#x60;nextStep: PASSWORD_CHANGE&#x60;, session restreinte). La session est liée à &#x60;deviceId&#x60;. Jeton d&#39;accès valable 15 min ; jeton de renouvellement à usage unique (rotation). 
  ///
  /// Parameters:
  /// * [mobileLoginRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MobileLogin200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MobileLogin200Response>> mobileLogin({ 
    required MobileLoginRequest mobileLoginRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/mobile/auth/login';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(MobileLoginRequest);
      _bodyData = _serializers.serialize(mobileLoginRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MobileLogin200Response? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MobileLogin200Response),
      ) as MobileLogin200Response;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MobileLogin200Response>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Déconnexion de l&#39;application mobile (révoque les jetons de la session)
  /// 
  ///
  /// Parameters:
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> mobileLogout({ 
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/mobile/auth/logout';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'csrfToken',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },{
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': '__Host-fp_at',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Renouveler les jetons (rotation, réutilisation &#x3D; révocation de toute la session)
  /// 
  ///
  /// Parameters:
  /// * [mobileRefreshRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MobileSession] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MobileSession>> mobileRefresh({ 
    required MobileRefreshRequest mobileRefreshRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/mobile/auth/refresh';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(MobileRefreshRequest);
      _bodyData = _serializers.serialize(mobileRefreshRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MobileSession? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MobileSession),
      ) as MobileSession;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MobileSession>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Résoudre le défi MFA depuis l&#39;application mobile
  /// 
  ///
  /// Parameters:
  /// * [mobileMfaVerifyRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MobileSession] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MobileSession>> mobileVerifyMfa({ 
    required MobileMfaVerifyRequest mobileMfaVerifyRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/mobile/auth/mfa/verify';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(MobileMfaVerifyRequest);
      _bodyData = _serializers.serialize(mobileMfaVerifyRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MobileSession? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MobileSession),
      ) as MobileSession;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MobileSession>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Renouvelle la session (rotation du jeton de rafraîchissement)
  /// Authentifiée par le cookie &#x60;__Secure-fp_rt&#x60; (&#x60;Path&#x3D;/v1/auth&#x60;) et l&#39;en-tête &#x60;X-FlexiPay-Client: web&#x60; (pré-vol CORS) ; pas de &#x60;X-CSRF-Token&#x60; (c&#39;est le moyen de le récupérer après un rechargement, §6). Rotation : nouveau jeton d&#39;accès, nouveau jeton de rafraîchissement, nouveau &#x60;csrfToken&#x60;, état courant (&#x60;nextStep&#x60;). Jeton absent, invalide, expiré ou **réutilisé** (toute la famille est alors révoquée, SEC-A3) : &#x60;401 UNAUTHENTICATED&#x60; et cookies effacés. **Deux onglets** du même navigateur (cookies partagés) qui renouvellent en même temps : les demandes sont traitées l&#39;une après l&#39;autre ; un jeton tourné depuis moins de 30 s (famille non révoquée) reçoit &#x60;409 RESOURCE_STATE_CONFLICT&#x60;, sans nouveau jeton, sans révocation et sans toucher aux cookies : le client réessaie une fois, avec le cookie reçu par l&#39;autre onglet. Au-delà de 30 s, la réutilisation reste une détection de vol (révocation). Le jeton CSRF étant lié à la session, un onglet dont le jeton est devenu invalide (&#x60;403 CSRF_TOKEN_INVALID&#x60;) après le renouvellement d&#39;un autre onglet le récupère par cette route et rejoue une fois sa requête. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SessionResult] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SessionResult>> refreshSession({ 
    required String xFlexiPayClient,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/refresh';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SessionResult? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SessionResult),
      ) as SessionResult;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SessionResult>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Régénère les 10 codes de secours (les anciens sont annulés)
  /// Session **complète**. Preuve exigée comme pour un ré-enrôlement : &#x60;currentPassword&#x60; et &#x60;currentCode&#x60; (code TOTP ou code de secours encore valable) ; échecs comptés dans le verrouillage (&#x60;CURRENT_PASSWORD_INVALID&#x60;, &#x60;401 MFA_CODE_INVALID&#x60;). Renvoie 10 nouveaux codes une seule fois (DP n° 10). Journal d&#39;audit et notification au titulaire. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [mfaProofRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [RecoveryCodes] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<RecoveryCodes>> regenerateRecoveryCodes({ 
    required String xFlexiPayClient,
    required MfaProofRequest mfaProofRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/mfa/recovery-codes';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'csrfToken',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },{
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': '__Host-fp_at',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(MfaProofRequest);
      _bodyData = _serializers.serialize(mfaProofRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    RecoveryCodes? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(RecoveryCodes),
      ) as RecoveryCodes;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<RecoveryCodes>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Demande de réinitialisation du mot de passe
  /// Route **publique**. Réponse **toujours** &#x60;202&#x60;, identique et de durée comparable que le compte existe ou non (anti-énumération, §4) ; rate limiting par IP, route et identifiant haché. Mécanisme (DP n° 11), choisi **d&#39;après la forme de l&#39;identifiant saisi** (aucun oracle : le client sait déjà ce qu&#39;il a tapé) : - **e-mail** : lien à usage unique valable 15 min, jeton dans le fragment de l&#39;URL ; la   page de réinitialisation envoie &#x60;{ token, newPassword }&#x60; ; - **téléphone** : code SMS de 6 chiffres, valable 10 min, 5 essais ; la page envoie   &#x60;{ identifier, otp, newPassword }&#x60;. Une nouvelle demande annule le lien ou le code précédent. Un mot de passe temporaire expiré peut être remplacé par ce moyen (DP n° 15). Journal d&#39;audit. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [passwordForgotRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> requestPasswordReset({ 
    required String xFlexiPayClient,
    required PasswordForgotRequest passwordForgotRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/password/forgot';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(PasswordForgotRequest);
      _bodyData = _serializers.serialize(passwordForgotRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Réinitialise le mot de passe (lien par e-mail ou code SMS)
  /// Route **publique** (DP n° 11). Deux formes de corps : - **lien** &#x60;{ token, newPassword }&#x60; : le jeton est placé dans le **fragment** de l&#39;URL   (&#x60;#token&#x3D;…&#x60;), jamais envoyé au serveur dans l&#39;URL ni journalisé ; la page web le lit et   l&#39;envoie dans le corps. Jeton (WB2-S02) : au moins 128 bits issus d&#39;un générateur   cryptographique, stocké **haché** (SHA-256), usage unique, 15 min, invalidé par une   nouvelle demande ou par un changement de mot de passe. Jeton inconnu, utilisé ou   expiré : &#x60;400 VALIDATION_FAILED&#x60; (champ &#x60;/token&#x60;, code &#x60;INVALID_FORMAT&#x60;), sans   distinguer les cas ; - **code SMS** &#x60;{ identifier, otp, newPassword }&#x60; : 6 chiffres, 10 min, 5 essais au plus   (au-delà le code est annulé). Identifiant inconnu, code faux, épuisé ou expiré :   &#x60;400 VALIDATION_FAILED&#x60; (champ &#x60;/otp&#x60;, code &#x60;INVALID_FORMAT&#x60;), même réponse dans tous   les cas. Politique non respectée : &#x60;PASSWORD_POLICY_VIOLATION&#x60;. Succès : **toutes** les sessions du compte sont fermées (DP n° 12), aucune session n&#39;est ouverte (le client renvoie vers la connexion). La réinitialisation ne désactive **jamais** la MFA. Journal d&#39;audit et notification au titulaire. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [passwordResetRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> resetPassword({ 
    required String xFlexiPayClient,
    required PasswordResetRequest passwordResetRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/password/reset';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(PasswordResetRequest);
      _bodyData = _serializers.serialize(passwordResetRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// Démarre l&#39;enrôlement TOTP (secret et URI otpauth)
  /// Session restreinte &#x60;MFA_ENROLL&#x60; : sans corps. Session **complète** (changement d&#39;appareil d&#39;authentification, WB2-S01) : corps **obligatoire** &#x60;{ currentPassword, currentCode }&#x60;, &#x60;currentCode&#x60; étant un code de l&#39;**ancien** secret (ou, après décision, un code de secours) ; champ absent : &#x60;400 VALIDATION_FAILED&#x60; (&#x60;REQUIRED&#x60;) ; mot de passe faux : &#x60;CURRENT_PASSWORD_INVALID&#x60; ; code faux : &#x60;401 MFA_CODE_INVALID&#x60; ; chaque échec compte dans le verrouillage. L&#39;ancien secret reste **actif** jusqu&#39;à la confirmation du nouveau. Génère un **nouveau** secret à chaque appel (le précédent, non confirmé, est abandonné) ; il n&#39;est actif qu&#39;après &#x60;POST /v1/auth/mfa/enroll/confirm&#x60;. Le secret n&#39;est renvoyé **qu&#39;ici**, jamais journalisé ; le client l&#39;affiche une seule fois (QR généré côté client à partir d&#39;&#x60;otpauthUri&#x60;, rendu par &#x60;img&#x60;/&#x60;canvas&#x60;, jamais &#x60;innerHTML&#x60; ; saisie manuelle avec &#x60;secretBase32&#x60;) et ne le conserve pas. &#x60;Cache-Control: no-store&#x60;. Journal d&#39;audit : démarrage d&#39;enrôlement (sans le secret) ; notification au titulaire en session complète. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [mfaReEnrollmentRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [MfaEnrollment] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<MfaEnrollment>> startMfaEnrollment({ 
    required String xFlexiPayClient,
    MfaReEnrollmentRequest? mfaReEnrollmentRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/mfa/enroll';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'csrfToken',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },{
            'type': 'apiKey',
            'name': 'cookieAuth',
            'keyName': '__Host-fp_at',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'bearerAuth',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(MfaReEnrollmentRequest);
      _bodyData = mfaReEnrollmentRequest == null ? null : _serializers.serialize(mfaReEnrollmentRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    MfaEnrollment? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(MfaEnrollment),
      ) as MfaEnrollment;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<MfaEnrollment>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Réponse au défi MFA (code TOTP ou code de secours)
  /// Route **publique** (le défi tient lieu d&#39;authentification partielle). Corps : &#x60;code&#x60; (TOTP RFC 6238 à 6 chiffres, DP n° 23) **ou** &#x60;recoveryCode&#x60; (code de secours à usage unique, DP n° 10 : consommé, journalisé et notifié au titulaire). Échecs comptés dans le compteur de verrouillage de la connexion. **Anti-rejeu** (WB2-S02) : tolérance de ±1 pas de 30 s ; un code accepté est refusé (&#x60;MFA_CODE_INVALID&#x60;) pour ce compte jusqu&#39;à la fin de sa fenêtre de validité. Erreurs : &#x60;401 MFA_CODE_INVALID&#x60; (code faux, le défi reste valable jusqu&#39;au verrouillage), &#x60;401 MFA_CHALLENGE_EXPIRED&#x60; (défi inconnu, déjà utilisé, expiré ou invalidé par le verrouillage : retour à la connexion). Journal d&#39;audit : succès et échec. 
  ///
  /// Parameters:
  /// * [xFlexiPayClient] - Canal du client. `web` : session par cookies + `csrfToken` dans le corps (§6, §10). En-tête personnalisé : impose un pré-vol CORS. La valeur `mobile` sera ajoutée avec le contrat mobile (non cassant). 
  /// * [mfaVerifyRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SessionResult] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SessionResult>> verifyMfa({ 
    required String xFlexiPayClient,
    required MfaVerifyRequest mfaVerifyRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/auth/mfa/verify';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'X-FlexiPay-Client': xFlexiPayClient,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(MfaVerifyRequest);
      _bodyData = _serializers.serialize(mfaVerifyRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SessionResult? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SessionResult),
      ) as SessionResult;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SessionResult>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}

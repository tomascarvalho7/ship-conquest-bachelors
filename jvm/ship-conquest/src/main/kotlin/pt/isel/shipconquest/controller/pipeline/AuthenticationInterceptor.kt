package pt.isel.shipconquest.controller.pipeline

import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.stereotype.Component
import org.springframework.web.method.HandlerMethod
import org.springframework.web.servlet.HandlerInterceptor
import pt.isel.shipconquest.domain.user.User


@Component
class AuthenticationInterceptor(
    private val authorizationHeaderProcessor: AuthorizationHeaderProcessor,
) : HandlerInterceptor {

    override fun preHandle(request: HttpServletRequest, response: HttpServletResponse, handler: Any): Boolean {
        if (handler is HandlerMethod && handler.methodParameters.any { it.parameterType == User::class.java }
        ) {
            val user = authorizationHeaderProcessor.process(request.getHeader(NAME_AUTHORIZATION_HEADER))

            return if (user == null) {
                response.addHeader(NAME_WWW_AUTHENTICATE_HEADER, AuthorizationHeaderProcessor.SCHEME)
                response.sendError(401)
                false
            } else {
                UserArgumentResolver.addUserTo(user, request)
                true
            }
        }
        return true
    }

    companion object {
        private const val NAME_AUTHORIZATION_HEADER = "Authorization"
        private const val NAME_WWW_AUTHENTICATE_HEADER = "WWW-Authenticate"
    }
}
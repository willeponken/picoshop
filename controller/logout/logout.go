package logout

import (
	"net/http"

	"github.com/wstrm/picoshop/middleware/auth"
)

type logoutHandler struct {
	http.Handler
	authManager *auth.Manager
}

func (l *logoutHandler) ServeHTTP(writer http.ResponseWriter, request *http.Request) {
	// Logout will ignore any method or the like and always try to logout any known user
	l.authManager.Logout(writer, request)
	http.Redirect(writer, request, "/", http.StatusSeeOther)
}

func NewHandler(authManager *auth.Manager) *logoutHandler {
	return &logoutHandler{
		authManager: authManager,
	}
}

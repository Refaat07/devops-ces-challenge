from flask import Flask, request, render_template
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_port=1, x_prefix=1)

@app.route('/')
def hello_world():
    user_email = request.headers.get('X-Goog-Authenticated-User-Email') or \
                 request.headers.get('X-Forwarded-Email') or \
                 request.headers.get('X-Forwarded-User') or \
                 'Guest'
    
    # 2. Clean up the string (Google IAP often prepends "accounts.google.com:")
    if user_email.startswith('accounts.google.com:'):
        user_email = user_email.split(':', 1)[1]
    # render_template looks in the 'templates' folder automatically
    return render_template('index.html', user_email=user_email)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
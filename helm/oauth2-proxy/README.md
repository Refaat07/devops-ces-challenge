# OAuth2 Proxy Helm Chart

This chart deploys OAuth2 Proxy for authentication with your Nginx Ingress.

## Installation

### 1. Get OAuth Credentials

For Google OAuth:
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing one
3. Enable Google+ API
4. Create OAuth 2.0 Credentials (Web Application)
5. Set authorized redirect URI to: `https://mrefaat.me/oauth2/callback`
6. Copy the Client ID and Client Secret

### 2. Generate Cookie Secret

```bash
python3 -c 'import secrets; print(secrets.token_urlsafe(32))'
```

### 3. Install the Chart

```bash
helm install oauth2-proxy ./oauth2-proxy \
  --set oauth.clientId=YOUR_CLIENT_ID \
  --set oauth.clientSecret=YOUR_CLIENT_SECRET \
  --set oauth.cookieSecret=YOUR_COOKIE_SECRET \
  --set proxyConfig.redirectUrl=https://your-domain.com/oauth2/callback \
  --set oauth.issuerUrl=https://accounts.google.com \
  --set proxyConfig.upstreamUrl=http://backend:80
```

Or with a values file:

```bash
helm install oauth2-proxy ./oauth2-proxy -f values-prod.yaml
```

### 4. Verify Installation

```bash
kubectl get pods -l app=oauth2-proxy
kubectl logs -l app=oauth2-proxy
```

## Configuration

Key configuration options:

- `oauth.provider` - OAuth provider (oidc, google, github, etc.)
- `oauth.issuerUrl` - OIDC issuer URL
- `oauth.clientId` - OAuth Client ID
- `oauth.clientSecret` - OAuth Client Secret
- `oauth.cookieSecret` - Session cookie encryption secret
- `proxyConfig.redirectUrl` - OAuth redirect URI
- `proxyConfig.upstreamUrl` - Backend service to proxy to
- `proxyConfig.emailDomains` - Allowed email domains
- `proxyConfig.allowedEmails` - Specific allowed email addresses

## Example values-prod.yaml

```yaml
replicaCount: 3

oauth:
  provider: oidc
  issuerUrl: https://accounts.google.com
  clientId: YOUR_CLIENT_ID
  clientSecret: YOUR_CLIENT_SECRET
  cookieSecret: YOUR_COOKIE_SECRET

proxyConfig:
  redirectUrl: https://mrefaat.me/oauth2/callback
  upstreamUrl: http://backend:80
  emailDomains:
    - "example.com"
    - "company.com"
  allowedEmails:
    - user@example.com

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

## How It Works

1. User accesses `https://mrefaat.me`
2. Nginx Ingress intercepts request and calls OAuth2 Proxy auth URL
3. If not authenticated, redirects to OAuth provider login
4. After successful authentication, session cookie is set
5. Subsequent requests are proxied to the backend service
6. Nginx adds authenticated user info in headers

## Troubleshooting

Check logs:
```bash
kubectl logs -l app=oauth2-proxy --tail=100 -f
```

Test the OAuth2 Proxy endpoint:
```bash
kubectl port-forward svc/oauth2-proxy 4180:80
curl http://localhost:4180/ping
```

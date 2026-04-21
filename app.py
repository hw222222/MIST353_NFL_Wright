from a2wsgi import ASGIMiddleware

from API.nfl_playoffs_api import app as asgi_app

app = ASGIMiddleware(asgi_app)

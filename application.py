from a2wsgi import ASGIMiddleware

from API.nfl_playoffs_api import app as asgi_app

# Azure's default gunicorn startup expects a WSGI callable named `app`
# in `application.py`, so we adapt the FastAPI ASGI app here.
app = ASGIMiddleware(asgi_app)

from flask import Flask
from flask_login import LoginManager
from config_files.config import Config
from config_files.models import db, Korisnik
from instance.routes import routes  # <- ispravka ovde

login_manager = LoginManager()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    login_manager.init_app(app)

    app.register_blueprint(routes)

    @login_manager.user_loader
    def load_user(user_id):
        return Korisnik.query.get(int(user_id))

    return app

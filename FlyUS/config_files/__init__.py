from flask import Flask, render_template
from flask_login import LoginManager
from config_files.config import Config
from config_files.models import db, Korisnik
from instance.routes import routes 

login_manager = LoginManager()

def create_app():
    app = Flask(__name__, template_folder="../templates", static_folder="../static")
    app.config.from_object(Config)

    db.init_app(app)
    login_manager.init_app(app)

    app.register_blueprint(routes)

    @login_manager.user_loader
    def load_user(user_id):
        return Korisnik.query.get(int(user_id))

    
    @app.route("/")
    def index():
        return render_template("index.html")
    
    @app.route("/letovi")
    def prikaz_letova():
        return render_template("letovi.html")


    return app
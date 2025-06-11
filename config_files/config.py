class Config:
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:admin_password@localhost:3306/air_agency'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'very_secret_key'
    REMEMBER_COOKIE_DURATION = 3600


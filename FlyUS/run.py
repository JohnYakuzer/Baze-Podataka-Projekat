from config_files import create_app


app = create_app()
static_folder='static'
if __name__ == "__main__":
    app.run(debug=True)


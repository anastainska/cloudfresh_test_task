import os
from flask import Flask, render_template
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('FLASK_SECRET_KEY')


@app.route('/')
def index():
    cafes = ['McDonald''s', 'KFC', 'Puzata Hata']
    return render_template('index.html', cafe=cafes)


@app.route('/cafe/<cf>')
def cafe(cf):
    return "This is " + str(cf)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

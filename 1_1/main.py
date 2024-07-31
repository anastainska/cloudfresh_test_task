from flask import Flask, render_template

app = Flask(__name__)


@app.route('/')
def index():
    cafes = ['McDonald''s', 'KFC', 'Puzata Hata']
    return render_template('index.html', cafe=cafes)


@app.route('/cafe/<cf>')
def cafe(cf):
    return "This is " + str(cf)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

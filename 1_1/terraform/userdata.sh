#!/bin/bash
sudo apt update -y
sudo apt install python3 python3-pip -y python3-venv nginx -y

mkdir flask-app && cd flask-app
python3 -m venv venv
source venv/bin/activate
pip3 install Flask

mkdir templates
cd templates
echo "<html>
    <body>
        <h1>Let's eat!</h1>
        <ul>
        {% for cf in cafe %}
        <li><a href=\"/cafe/{{ cf }}\">{{ cf }}</a></li>
        {% endfor %}
        </ul>
    </body>
</html>" > index.html

cd ..
echo "from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    cafes = ['McDonald''s', 'KFC', 'Puzata Hata']
    return render_template('index.html', cafe=cafes)

@app.route('/cafe/<cf>')
def cafe(cf):
    return 'This is ' + str(cf)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
" > main.py

python main.py &

cd /etc/nginx/sites-enabled
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
echo "server {
    listen 80;
    listen [::]:80;
    server_name "$PUBLIC_IP";

    location / {
        proxy_pass http://127.0.0.1:5000;
        include proxy_params;
    }
}" > "$PUBLIC_IP"
sudo systemctl restart nginx
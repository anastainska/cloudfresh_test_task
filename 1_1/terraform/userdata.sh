#!/bin/bash
sudo apt update -y
sudo apt install python3 python3-pip -y python3-venv nginx openssl -y

sudo apt install curl unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

FLASK_SECRET_KEY=$(aws ssm get-parameter --name FLASK_SECRET_KEY --with-decryption --query Parameter.Value --output text)

echo "FLASK_SECRET_KEY=$FLASK_SECRET_KEY" | sudo tee -a /etc/environment
source /etc/environment

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
import os

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ.get('FLASK_SECRET_KEY')

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

sudo chmod 700 /etc/nginx/ssl
sudo openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/nginx-selfsigned.key -x509 -days 365 -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=Department/CN=$(curl -s http://checkip.amazonaws.com)"

cd /etc/nginx/sites-enabled
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)
echo "server {
    listen 80;
    listen [::]:80;
    server_name "$PUBLIC_IP";

    return 301 https://"$PUBLIC_IP"$request_uri;
}

server {
    listen 443 ssl;
    server_name "$PUBLIC_IP";

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    location / {
        proxy_pass http://127.0.0.1:5000;
        include proxy_params;
    }
}" > "$PUBLIC_IP"
sudo systemctl restart nginx
from flask import Flask, render_template
import requests
app = Flask(__name__)
# Define your token
TOKEN = 'zcRBtVNSpszlYbOJhtJutZsLVPPojEhY'
@app.route('/')
def index():
    # Fetch data from the API
    api_url = 'https://www.ncei.noaa.gov/cdo-web/api/v2/datasets'
    headers = {'token': TOKEN}
    response = requests.get(api_url, headers=headers)
    data = response.json()
    # Pass the data to the HTML template
    return render_template('index.html', data=data)
if __name__ == '__main__':
    app.run(debug=False)
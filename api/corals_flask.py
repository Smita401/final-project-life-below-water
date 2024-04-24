from flask import Flask, jsonify, render_template
import os
from flask_basicauth import BasicAuth
import pymysql
from flask import abort
import json
from flask import request
import math
from collections import defaultdict
from flask_swagger_ui import get_swaggerui_blueprint


app = Flask(__name__, static_folder='static')

# Assuming you have some configuration for your Flask app
app.config.from_file("flask_config.json", load=json.load)

PAGE_SIZE = 100

def remove_null_fields(obj):
    return {k: v for k, v in obj.items() if v is not None}

# Define the route for serving the Swagger UI
@app.route('/corals_data')
def corals_data():
    # You can customize the response here if needed
    return "Welcome to the Corals Data API!"

swaggerui_blueprint = get_swaggerui_blueprint(
    '/corals_data/docs',  # Swagger UI endpoint URL
    '/static/opencoralsapi.yaml',  # Path to your OpenAPI specification file
    config={'app_name': "Corals Data API"}  # Swagger UI config
)

# @app.route('/corals_data/docs')
# def swagger_ui():
#     return swaggerui_blueprint

from flask import send_from_directory

@app.route('/static/<path:path>')
def send_static(path):
    return send_from_directory('static', path)

app.register_blueprint(swaggerui_blueprint)

# Define your other routes and functions here

@app.route("/samples/<int:sample_id>")
def sample(sample_id):
    db_conn = pymysql.connect(host="localhost",
                              user="root",
                              password='SQL2024!',
                              database="final_project",
                              cursorclass=pymysql.cursors.DictCursor)
    with db_conn.cursor() as cursor:
        cursor.execute("""SELECT * 
                       FROM sample s WHERE s.sample_id=%s""", (sample_id, ))
        sample = cursor.fetchone()
        if not sample:
            abort(404)
    db_conn.close()
    return jsonify(remove_null_fields(sample))

@app.route("/samples")
def samples():
    page = int(request.args.get('page', 1))
    page_size = int(request.args.get('page_size', PAGE_SIZE))
    page_size = min(page_size, PAGE_SIZE)

    db_conn = pymysql.connect(host="localhost",
                              user="root",
                              password='SQL2024!',
                              database="final_project",
                              cursorclass=pymysql.cursors.DictCursor)

    with db_conn.cursor() as cursor:
        cursor.execute("""SELECT *
                       FROM sample s
                       ORDER BY s.sample_id
                       LIMIT %s
                       OFFSET %s""",
                       (page_size, (page - 1) * page_size))

        samples = cursor.fetchall()
        if not samples:
            abort(404)
        for s in samples:
            s = remove_null_fields(s)

    with db_conn.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) AS total FROM sample")
        total = cursor.fetchone()
        last_page = math.ceil(total['total'] / page_size)

    db_conn.close()
    if page == last_page:
        return jsonify({'samples': samples, 'next_page': None,
                        'last_page': f'/samples?page={last_page}&page_size={page_size}'})
    else:
        return jsonify({'samples': samples, 'next_page': f'/samples?page={page+1}&page_size={page_size}',
                        'last_page': f'/samples?page={last_page}&page_size={page_size}'})

@app.route("/samples/year/<int:year>")
def samples_by_year(year):
    page = int(request.args.get('page', 1))
    page_size = int(request.args.get('page_size', PAGE_SIZE))

    db_conn = pymysql.connect(host="localhost",
                              user="root",
                              password='SQL2024!',
                              database="final_project",
                              cursorclass=pymysql.cursors.DictCursor)

    with db_conn.cursor() as cursor:
        cursor.execute("""SELECT * 
                          FROM sample 
                          WHERE YEAR(date) = %s
                          ORDER BY sample_id
                          LIMIT %s OFFSET %s""", (year, page_size, (page - 1) * page_size))

        samples = cursor.fetchall()
        if not samples:
            abort(404)

    with db_conn.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) AS total FROM sample WHERE YEAR(date) = %s", (year,))
        total = cursor.fetchone()['total']
        last_page = math.ceil(total / page_size)

    db_conn.close()

    next_page = f'/samples/year/{year}?page={page + 1}&page_size={page_size}' if page < last_page else None
    last_page_url = f'/samples/year/{year}?page={last_page}&page_size={page_size}'

    return jsonify({
        'samples': [remove_null_fields(sample) for sample in samples],
        'next_page': next_page,
        'last_page': last_page_url
    })

@app.route("/get_sample_ids")
def get_sample_ids():
    page = int(request.args.get('page', 1))
    page_size = int(request.args.get('page_size', PAGE_SIZE))

    db_conn = pymysql.connect(host="localhost",
                              user="root",
                              password='SQL2024!',
                              database="final_project",
                              cursorclass=pymysql.cursors.DictCursor)

    with db_conn.cursor() as cursor:
        cursor.execute("""SELECT sample_id
                       FROM sample s
                       ORDER BY s.sample_id
                       LIMIT %s
                       OFFSET %s""",
                       (page_size, (page - 1) * page_size))

        sample_ids = cursor.fetchall()
        if not sample_ids:
            abort(404)

    with db_conn.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) AS total FROM sample")
        total = cursor.fetchone()
        last_page = math.ceil(total['total'] / page_size) - 1

    db_conn.close()

    if page == last_page:
        return jsonify({'sample_ids': sample_ids, 'next_page': None,
                        'last_page': f'/get_sample_ids?page={last_page}&page_size={page_size}'})
    else:
        return jsonify({'sample_ids': sample_ids,
                        'next_page': f'/get_sample_ids?page={page + 1}&page_size={page_size}',
                        'last_page': f'/get_sample_ids?page={last_page}&page_size={page_size}'})

if __name__ == '__main__':
    app.run(debug=True)

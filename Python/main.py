import json
import os
from flask import Flask, request, jsonify
import werkzeug
import callModel as model



response=''
data=[]
app = Flask(__name__)

@app.route('/name', methods=[ 'POST','GET'])
    
    
def upload_image():
    if 'image' not in request.files:
        print("erroorrr")
        return 'No image uploaded', 400

    image = request.files['image']
    filepath=os.path.join('my_app/lib/src/', image.filename)
    image.save(filepath)
    sonuc=model.predict(filepath)
    print("sonuc "+sonuc)
    data=[]
    if(str(sonuc)=="ID_CARD"):
        result=model.read_ID_card(filepath)
        for detection in result:
            print(detection[1])
            data.append(detection[1])
        response_data = {
            'status': 'success',
            'message': 'File received and processed successfully',
            'data': data
        }
        return jsonify(response_data), 200
    else:
        response_data = {
            'status': 'failed',
            'message': 'File is not Id Card'
        }
        return jsonify(response_data), 404



       

if __name__ == '__main__':
    app.run( host='0.0.0.0')

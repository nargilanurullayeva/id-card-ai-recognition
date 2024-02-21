import cv2
import joblib
import easyocr


model = joblib.load('my_model.pkl')

CATEGORIES=["ID_CARD", "OTHERS"]

def predict(filepath):
    IMG_SIZE=100
    img_array=cv2.imread(filepath)
    new_array=cv2.resize(img_array, (IMG_SIZE, IMG_SIZE))
    new_array=new_array.reshape(-1, IMG_SIZE, IMG_SIZE, 3)
    #sonuc=int(prediction[0][0])
    #print('sonuc: '+str(sonuc))
    prediction=model.predict([new_array])
    print(CATEGORIES[int(prediction[0][0])])
    return CATEGORIES[int(prediction[0][0])] 

# predict('./lib/src/991.jpg')

def read_ID_card(filepath):
    print("resim geldi")
    reader=easyocr.Reader(['tr'], gpu=False)
    result=reader.readtext(filepath)
    print(result)
    return(result)



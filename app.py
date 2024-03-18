from flask import Flask, request, jsonify
import joblib
from flask_cors import CORS
import pandas as pd
import numpy as np
import tensorflow as tf

app = Flask(__name__)

CORS(app)

def predict_size(weight, age, height):
    # Load the trained model
    model = tf.keras.models.load_model('./model2.h5')

    # Create a DataFrame from the user input
    user_input = pd.DataFrame({'Weight': [weight], 'Age': [age], 'Height': [height]})

    # Use the model to predict the T-shirt size
    prediction = model.predict(user_input)
    size_labels = {'XXXL': 0, 'XXL': 1, 'XL': 2, 'L': 3, 'M': 4, 'S': 5, 'XXS': 6}
    # Convert the prediction from numerical labels back to T-shirt sizes
    size_labels_inverse = {v: k for k, v in size_labels.items()}
    predicted_size = size_labels_inverse[np.argmax(prediction)]

    return predicted_size

@app.route('/predict', methods=['POST'])
def predict():
    weight = request.form.get('weight')
    age = request.form.get('age')
    height = request.form.get('height')

    if weight is None or age is None or height is None:
        return jsonify({'error': 'Please provide weight, age, and height as form parameters.'}), 400

    prediction = predict_size(float(weight), int(age), float(height))
    return jsonify({'prediction': prediction})

if __name__ == '__main__':
     app.run(host='192.168.1.9', debug=True)

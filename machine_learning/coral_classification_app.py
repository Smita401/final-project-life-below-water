import streamlit as st
import numpy as np
from PIL import Image
from tensorflow.keras.preprocessing import image
import tensorflow as tf

# Function to load and preprocess the uploaded image
def load_image(image_file):
    img = Image.open(image_file)
    img = img.resize((224, 224))  # Resize image to match model input size
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)  # Make batch of one
    img_array /= 255.0  # Preprocess the image
    return img_array, img

# Load the model
@st.cache(allow_output_mutation=True)  # Cache the model to avoid loading it multiple times
def load_model(model_path):
    return tf.keras.models.load_model(model_path, compile=False)

# Main function to run the Streamlit app
def main():
    st.title("Coral Classification")

    # Upload image
    uploaded_file = st.file_uploader("Choose an image...", type=["jpg", "jpeg", "png"])

    if uploaded_file is not None:
        # Display the uploaded image
        st.image(uploaded_file, caption='Uploaded Image.', use_column_width=True)

        # Load the model
        model = load_model('my_model.keras')

        # Make predictions
        img_array, img = load_image(uploaded_file)
        predictions = model.predict(img_array)

        # Define class names (replace with your actual class names)
        class_names = ['healthy_corals', 'bleached_corals']

        # Get the predicted class index
        predicted_class_index = np.argmax(predictions[0])

        # Get the corresponding class name
        predicted_class_name = class_names[predicted_class_index]

        # Display the predicted label
        st.write(f"Predicted Label: {predicted_class_name}")

# Run the app
    st.markdown(
        """
        <style>
        body {
            background-image: url('ocean_bk.jpg'); /* Replace 'ocean_background.jpg' with the path to your ocean background image */
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-position: center;
        }
        </style>
        """,
        unsafe_allow_html=True
    )
if __name__ == '__main__':
    main()

# import streamlit as st

# def main():
#     # Add title and description
#     st.title("Coral Classification")
#     st.write("Upload an image of coral to classify its health.")

    # Upload image and make predictions (you can include your existing code here)

# Run the app
# if __name__ == '__main__':
    # Apply background image using inline CSS


    # Run the main function
    # main()


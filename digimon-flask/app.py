from flask import Flask, request, jsonify
import pandas as pd
import pickle
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)

# Load the model and data
with open('tfidf_model.pkl', 'rb') as f:
    vectorizer = pickle.load(f)

data = pd.read_csv('digimon_data.csv')
tfidf_matrix = vectorizer.transform(data['Description'])
cosine_sim = cosine_similarity(tfidf_matrix)

@app.route('/recommend', methods=['GET'])
def recommend():
    digimon_name = request.args.get('digimon_name')
    idx = data[data['Digimon'] == digimon_name].index[0]
    sim_scores = list(enumerate(cosine_sim[idx]))
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    sim_scores = sim_scores[1:6]
    digimon_indices = [i[0] for i in sim_scores]
    recommendations = data['Digimon'].iloc[digimon_indices].tolist()
    return jsonify(recommendations)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

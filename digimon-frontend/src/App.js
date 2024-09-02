import React, { useState } from "react";
import axios from "axios";
import "./App.css";

function App() {
  const [digimonName, setDigimonName] = useState("");
  const [recommendations, setRecommendations] = useState([]);

  const handleSearch = async () => {
    try {
      const apiHost = window.location.hostname;
      const apiUrl = `http://${apiHost}:8080/recommendations`;

      const response = await axios.get(apiUrl, {
        params: { digimonName: digimonName },
      });
      setRecommendations(response.data);
    } catch (error) {
      console.error("Error fetching recommendations", error);
    }
  };

  return (
    <div className="App">
      <h1>Digimon Recommendations</h1>
      <input
        type="text"
        placeholder="Enter Digimon Name"
        value={digimonName}
        onChange={(e) => setDigimonName(e.target.value)}
      />
      <button onClick={handleSearch}>Is there any more options?</button>

      {recommendations.length > 0 && (
        <ul>
          {recommendations.map((rec, index) => (
            <li key={index}>{rec}</li>
          ))}
        </ul>
      )}
    </div>
  );
}

export default App;
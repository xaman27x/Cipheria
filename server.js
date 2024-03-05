const express = require('express');
const { GoogleGenerativeAI } = require("@google/generative-ai");
const { v4: uuidv4 } = require('uuid');
const app = express();
const port = 3000;

// Initialize Google Generative AI
const genAI = new GoogleGenerativeAI('AIzaSyBqbXJb3vr2AAslojxyZF15JCYuUDOoOAs');


async function runGenerativeAI(prompt) {
    try {
        // Get the Generative Model (e.g., "gemini-pro")
        const model = genAI.getGenerativeModel({ model: "gemini-pro" });

        const result = await model.generateContent(prompt);
        const response = await result.response;
        const text = response.text();
        console.log(text);
        return text;
    } catch (error) {
        console.error('Error generating content:', error.message);
        throw error;
    }
}

app.use(express.static('public'));

app.get('/run-data-fetch', async (req, res) => {
    const { prompt } = req.query;

    try {
        const generatedText = await runGenerativeAI(prompt);
        res.send({ generatedText });
    } catch (error) {
        res.status(500).send({ error: 'Internal Server Error' });
    }
});

app.listen(port, () => {
    console.log(`Server listening at http://localhost:${port}`);
});

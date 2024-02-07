const express = require("express");
var cors = require('cors')
const app = express();

const { MongoClient } = require('mongodb');
app.use(express.json())
app.use(cors());

const corsOptions = {
    origin: '*',
}
app.use(cors(corsOptions))

const url = 'your mongodb database link';
const client = new MongoClient(url);

app.get("/getdata", async(req,res)=>{
    try {
        await client.connect();
        console.log("fetching data.......");
        const db = client.db('flutterapp');
        const collection = db.collection('names');
        const projection = { _id:0,name: 1 }; 
        const listing = await collection.find({}, projection).toArray(); 
        res.json(listing).sendStatus(200);

    } catch (error) {
        console.error(error)
      console.log("error")
    }
})



app.post("/adddata",async (req,res)=>{
   try {
    await client.connect();
    console.log("connected.......");
    const db = client.db('flutterapp');
    const collection = db.collection('names');
    const data= req.body.name;
    collection.insertMany([{name:data}]);
    console.log("data added");
    res.sendStatus(200)
    
   } catch (error) {
    console.error(error)
    console.log("error")
   }
})

app.delete('/deletepeople/:id', async(req, res) => {
    await client.connect();
    console.log("connected.......");
    const db = client.db('flutterapp');
    const collection = db.collection('names');
    const personId = req.params.id;
    const deleteResult = await collection.deleteOne({ name: personId });
console.log('Deleted documents =>', deleteResult);
    res.sendStatus(200);
  });

app.listen(3000,function(){
    console.log("server is running")
})

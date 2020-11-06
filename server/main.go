package main

/**
* Backend Golang API for Tangram mobile app
 */

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/gorilla/mux"

	_ "github.com/go-sql-driver/mysql"
)

// ER Diagram Design for Tangram: https://wiki.illinois.edu/wiki/display/CS411AAFA20/Sliced+Bread+-+ER+Design

var db *sql.DB
var err error

// UserData contains username and total likes for each valid user
type UserData struct {
	Username       string `json:"Username"`
	TotalLikes     int64  `json:"TotalLikes"`
	ProfilePicture string `json:"ProfilePicture"`
}

// MapData for frontend grid
type MapData struct {
	MapID   string `json:"MapID"`
	MapName string `json:"MapName"`
}

// PostData struct for each post on app
type PostData struct {
	PostID      string `json:"PostID"`
	Likes       int64  `json:"Likes"`
	Text        string `json:"Text"`
	TimePosted  string `json:"TimePosted"`
	Username    string `json:"Username"`
	VideoURL    string `json:"VideoURL"`
	XCoordinate int64  `json:"XCoordinate"`
	YCoordinate int64  `json:"YCoordinate"`
}

func getUser(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	username := mux.Vars(r)["username"] // get username from route

	result, err := db.Query("SELECT * from users WHERE Username = ?", username)

	if err != nil {
		panic(err.Error())
	}
	defer result.Close()

	var user UserData

	for result.Next() {
		err := result.Scan(&user.Username, &user.TotalLikes, &user.ProfilePicture)
		if err != nil {
			panic(err.Error())
		}
	}
	json.NewEncoder(w).Encode(user)
}

func createUser(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	query, err := db.Prepare("INSERT INTO users(Username, TotalLikes, ProfilePicture) VALUES(?, ?, ?)")
	if err != nil {
		panic(err.Error())
	}

	body, err := ioutil.ReadAll(r.Body) // get request body from POST request

	if err != nil {
		panic(err.Error())
	}

	data := make(map[string]string)
	json.Unmarshal(body, &data)

	_, err = query.Exec(data["Username"], data["TotalLikes"], data["ProfilePicture"])
	if err != nil {
		panic(err.Error())
	}

	fmt.Fprintf(w, "Created new user: %s", data["Username"])
}

func deleteUser(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	username := mux.Vars(r)["Username"]

	query, err := db.Prepare("DELETE FROM users where Username = ?")
	if err != nil {
		panic(err.Error())
	}
	_, err = query.Exec(username)

	fmt.Fprintf(w, "User with username = %s was deleted", username)
}

func getAllUsers(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	fmt.Printf("getAllUsers() called\n")
	var users []UserData
	result, err := db.Query("SELECT * FROM users")

	fmt.Printf("After query\n")
	if err != nil {
		panic(err.Error())
	}
	defer result.Close()
	for result.Next() {
		var user UserData
		err := result.Scan(&user.Username, &user.TotalLikes, &user.ProfilePicture)
		if err != nil {
			panic(err.Error)
		}
		users = append(users, user)
	}

	json.NewEncoder(w).Encode(users)
}

func getPost(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	postID := mux.Vars(r)["postID"] // get PostID from route

	result, err := db.Query("SELECT * from postID WHERE PostID = ?", postID)

	if err != nil {
		panic(err.Error())
	}
	defer result.Close()

	var post PostData
	for result.Next() {
		err := result.Scan(&post.PostID, &post.Likes, &post.Text, &post.TimePosted, &post.Username, &post.VideoURL, &post.XCoordinate, &post.YCoordinate)
		if err != nil {
			panic(err.Error())
		}
	}
	json.NewEncoder(w).Encode(post)
}

func createPost(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	query, err := db.Prepare("INSERT INTO post(PostID, Likes, Text, TimePosted, Username, VideoURL, XCoordinate, YCoordinate) VALUES(?, ?, ?, ?, ?, ?, ?, ?)")
	if err != nil {
		panic(err.Error())
	}

	body, err := ioutil.ReadAll(r.Body) // get request body from POST request

	if err != nil {
		panic(err.Error())
	}

	data := make(map[string]string)
	json.Unmarshal(body, &data) // store request body in data hashmap

	_, err = query.Exec(data["PostID"], data["Likes"], data["Text"], data["TimePosted"], data["Username"], data["VideoURL"], data["XCoordinate"], data["YCoordinate"])
	if err != nil {
		panic(err.Error())
	}

	fmt.Fprintf(w, "Created new user: %s", data["Username"])
}

func deletePost(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	postID := mux.Vars(r)["PostID"]

	query, err := db.Prepare("DELETE FROM post where PostID = ?")
	if err != nil {
		panic(err.Error())
	}
	_, err = query.Exec(postID)

	fmt.Fprintf(w, "User with username = %s was deleted", postID)
}

func getAllPosts(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var posts []PostData
	result, err := db.Query("SELECT * FROM post")

	if err != nil {
		panic(err.Error())
	}
	defer result.Close()
	for result.Next() {
		var post PostData
		err := result.Scan(&post.PostID, &post.Likes, &post.Text, &post.TimePosted, &post.Username, &post.VideoURL, &post.XCoordinate, &post.YCoordinate)
		if err != nil {
			panic(err.Error)
		}
		posts = append(posts, post)
	}

	json.NewEncoder(w).Encode(posts)
}

func main() {
	// database cursor init
	// db, err := sql.Open("mysql", "<user>:<password>@tcp(<ipaddress>)/<db_name>")

	fmt.Printf("connecting to database\n")
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()

	router := mux.NewRouter()

	// User Routes
	router.HandleFunc("/get-user/{Username}", createUser).Methods("GET")
	router.HandleFunc("/create-user", createUser).Methods("POST")
	router.HandleFunc("/delete-user/{Username}", deleteUser).Methods("DELETE")
	router.HandleFunc("/get-all-users", getAllUsers).Methods("GET")

	// Post Routes
	router.HandleFunc("/get-post/{PostID}", getPost).Methods("GET")
	router.HandleFunc("/create-post", createPost).Methods("POST")
	router.HandleFunc("/delete-post/{PostID}", deletePost).Methods("DELETE")
	router.HandleFunc("/get-all-posts", getAllPosts).Methods("GET")

	fmt.Printf("Running Server on port 5000\n")

	http.ListenAndServe(":5000", router)
}

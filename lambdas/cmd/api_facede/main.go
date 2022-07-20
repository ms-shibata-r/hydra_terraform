package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jinzhu/gorm"
)

type hydra_oauth2_access struct {
	Signature         string `json:signature`
	RequestId         string `json:request_id`
	RequestedAt       string `json:requested_at`
	ClientId          string `json:client_id`
	Scope             string `json:scope`
	GrantedScope      string `json:granted_scope`
	FormData          string `json:form_data`
	SessionData       string `json:session_data`
	Subject           string `json:subject`
	Active            string `json:active`
	RequestedAudience string `json:requested_audience`
	GrantedAudience   string `json:granted_audience`
	ChallengeId       string `json:challenge_id`
}

var (
	// DefaultHTTPGetAddress Default Address
	DefaultHTTPGetAddress = "https://checkip.amazonaws.com"

	// ErrNoIP No IP found in response
	ErrNoIP = errors.New("No IP in HTTP response")

	// ErrNon200Response non 200 status code in response
	ErrNon200Response = errors.New("Non 200 Response found")
)

func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	resp, err := http.Get(DefaultHTTPGetAddress)
	if err != nil {
		return events.APIGatewayProxyResponse{}, err
	}

	if resp.StatusCode != 200 {
		return events.APIGatewayProxyResponse{}, ErrNon200Response
	}

	ip, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return events.APIGatewayProxyResponse{}, err
	}

	if len(ip) == 0 {
		return events.APIGatewayProxyResponse{}, ErrNoIP
	}
	log.Println("1")
	db := gormConnect()
	defer db.Close()
	log.Println("2")
	// 構造体のインスタンス化
	eventsEx := []hydra_oauth2_access{}
	db.Table("hydra_oauth2_access").Find(&eventsEx)
	log.Println("3")
	var test string
	for _, v := range eventsEx {
		test += v.ClientId
	}
	log.Println("4")
	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprintf("test, %v, %v", string(ip), test),
		StatusCode: 200,
	}, nil
}

func gormConnect() *gorm.DB {
	DBMS := "mysql"
	USER := "hydra"
	PASS := "hydra2022"
	PROTOCOL := "tcp(hydra-rds-proxy.proxy-cggh3018flmj.ap-northeast-1.rds.amazonaws.com:3306)"
	DBNAME := "hydra"

	CONNECT := USER + ":" + PASS + "@" + PROTOCOL + "/" + DBNAME
	db, err := gorm.Open(DBMS, CONNECT)

	if err != nil {
		panic(err.Error())
	}
	return db
}

func main() {
	lambda.Start(handler)
}

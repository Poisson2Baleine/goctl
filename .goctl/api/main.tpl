package main

import (
	"flag"
	"fmt"
	"github.com/poisson2baleine/errors"
	"github.com/tal-tech/go-zero/rest/httpx"
	"online-judge/api/internal/types"
	"time"

	{{.importPackages}}
)

var configFile = flag.String("f", "etc/{{.serviceName}}.yaml", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &c)

	ctx := svc.NewServiceContext(c)
	server := rest.MustNewServer(c.RestConf)
	defer server.Stop()

	httpx.SetErrorHandler(func(err error) (int, interface{}) {
		return 200, &types.CommonResp{
			Code:      errors.GetErrorCode(err),
			Msg:       err.Error(),
			Timestamp: time.Now().Unix(),
			Data:      nil,
		}
	})
	handler.RegisterHandlers(server, ctx)

	fmt.Printf("Starting server at %s:%d...\n", c.Host, c.Port)
	server.Start()
}

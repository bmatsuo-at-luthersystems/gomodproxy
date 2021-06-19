package main

import (
	"os"
	"os/signal"
	"syscall"
	"time"

	"go.uber.org/zap"
)

func main() {
	logger := zap.NewExample()
	ch := make(chan os.Signal, 2)
	signal.Notify(ch, os.Interrupt, os.Signal(syscall.SIGTERM))
	go logger.Info("Dr Jones, throw me the idle!!!")
	sig := <-ch
	logger.Info("Termination signal received", zap.Any("signal", sig))
	logger.Info("I hate snakes!!!!!")
}

func timestamp() string {
	return time.Now().Format(time.RFC3339)
}

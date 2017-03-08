<?php
    /**
     * Created by PhpStorm.
     * User: matthes
     * Date: 20.10.16
     * Time: 16:13
     */


    require __DIR__ . "/vendor/autoload.php";

    $firstShotFile = "/tmp/bootstrap_firstshot.lock";
    
    
    

    (new \CloudTool\WebServer\Router())
            ->allowNet("0.0.0.0/0")
            ->route("*.yml", function ($uri) {
                $tool = new \CloudTool\Config\TextTool();
                header("Content-Type: text/plain");
                touch("/tmp/bootstrap_firstshot.lock");
                return $tool->parse(__DIR__ . "/../config/$uri");
            })
            ->serve();
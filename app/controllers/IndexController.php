<?php

class IndexController extends ControllerBase
{

    public function indexAction()
    {
    	$departments = Department::find();
    	$this->view->departments = $departments;
    	$employees = Employee::find();
    	$this->view->employees = $employees;
    }

}


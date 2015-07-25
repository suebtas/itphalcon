<?php
use Phalcon\Mvc\Model;

class Employee extends Model
{
	public function initialize()
    {
        $this->belongsTo('DNO', 'department', 'DNUMBER', NULL);
    }
}

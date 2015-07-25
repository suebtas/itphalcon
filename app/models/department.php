<?php
use Phalcon\Mvc\Model;

class Department extends Model
{
	public function initialize()
    {
        $this->belongsTo('MGRSSN', 'employee', 'SSN', NULL);
    }
}

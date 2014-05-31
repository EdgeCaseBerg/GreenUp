<?php 
/* User Object Class
 * Defines simple interface to hold User data.
*/
class User{
	public $ident    ="";
	public $nickname ="";
	public $realname ="";
	public $lastseen ="";
	public $hash    ="";

	private function _ensure_data(array $data){
		foreach( array("id","nickname","realname","lastseen","hash") as $field) {
			if( ! isset($data[$field]))
				$data[$field] = NULL;
		}
		return $data;
	}

	public function __construct(array $data ){
		$data = $this->_ensure_data($data);
		$this->ident = $data['id'];
		$this->nickname = $data['nickname'];
		$this->realname = $data['realname'];
		$this->lastseen = intval($data['lastseen']); /* Should be Unix Timestamp */
		$this->hash = $data['hash'];
	}

	public function getUnique(){
		return spl_object_hash($this);
	}

}

?>
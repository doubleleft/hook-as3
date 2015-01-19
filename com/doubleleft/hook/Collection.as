package com.doubleleft.hook
{

	public class Collection
	{
		protected var client : Client;

		public var name : String;
		public var segments : String;

		protected var options : Dictionary;
		protected var wheres : Array;
		protected var ordering : Array;
		protected var _group : Array;
		protected var _limit : int;
		protected var _offset : int;
		protected var _remember : int;

		public function Collection(client : Client, name : String)
		{
			this.client = client;
			this.name = name;
			this.segments = "collection/" + this.name;
		}

		public function create(data) : Request {
		}

		public function get() : Request {
		}

		public function find(_id) : Request {
		}

		public function count(field) : Request {
		}

		public function max(field) : Request {
		}

		public function min(field) : Request {
		}

		public function avg(field) : Request {
		}

		public function sum(field) : Request {
		}

		public function first() : Request {
		}

		public function firstOrCreate(data) : Request {
		}

		public function remove(_id) : Request {
		}

		public function update(_id, data) : Request {
		}

		public function increment(field, value) : Request {
		}

		public function decrement(field, value) : Request {
		}

		public function updateAll(data) : Request {
		}
		///////

		public function select() : Collection {
			return this;
		}

		public function where(objects, _operation, _value, _boolean) : Collection {
			return this;
		}

		public function orWhere(objects, _operation, _value) : Collection {
			return this;
		}

		public function join() : Collection {
			return this;
		}

		public function distinct() : Collection {
			return this;
		}

		public function group() : Collection {
			return this;
		}

		public function then() : Collection {
			return this;
		}

		public function debug(func) : Collection {
			return this;
		}

		public function reset() : Collection {
			return this;
		}

		public function sort(field, direction) : Collection {
			return this;
		}

		public function limit(int) : Collection {
			return this;
		}

		public function offset(int) : Collection {
			return this;
		}

		public function remember(minutes) : Collection {
			return this;
		}

		public function channel(options) : Collection {
			return this;
		}

		public function paginate(perPage, onComplete, onError) : Collection {
			return this;
		}

		public function drop() : Collection {
			return this;
		}

		public function addWhere(field, operation, value, boolean) : Collection {
			return this;
		}

		public function buildQuery() : Object {
			return this;
		}

	}

}

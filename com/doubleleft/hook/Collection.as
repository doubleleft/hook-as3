package com.doubleleft.hook
{

	public class Collection
	{
		protected var client : Client;

		public var name : String;
		public var segments : String;

		protected var options : Object;
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

			this.reset();
		}

		public function create(data : Object) : Request {
			this.options.data = data
			return this.client.post(this.segments, this.buildQuery());
		}

		public function get() : Request {
			return this.client.get(this.segments, this.buildQuery());
		}

		public function find(_id : Object) : Request {
			return this.client.get(this.segments + "/" + _id, this.buildQuery());
		}

		public function count(field : String = "*") : Request {
			this.options.aggregation = { method: "count", field: field };
			return this.get();
		}

		public function max(field : String) : Request {
			this.options.aggregation = { method: "max", field: field };
			return this.get();
		}

		public function min(field : String) : Request {
			this.options.aggregation = { method: "min", field: field };
			return this.get();
		}

		public function avg(field : String) : Request {
			this.options.aggregation = { method: "avg", field: field };
			return this.get();
		}

		public function sum(field : String) : Request {
			this.options.aggregation = { method: "sum", field: field };
			return this.get();
		}

		public function first() : Request {
			this.options.first = 1;
			return this.get();
		}

		public function firstOrCreate(data : Object) : Request {
			this.options.first = 1;
			this.options.data = data;
			return this.client.post(this.segments, this.buildQuery());
		}

		public function remove(_id : Object = null) : Request {
			var path : String = this.segments;
			if (_id != null) {
				path += "/" + _id;
			}
			return this.client.remove(path, this.buildQuery());
		}

		public function update(_id : String, data : Object) : Request {
			return this.client.post(this.segments + "/" + _id, data);
		}

		public function increment(field : String, value : Object = null) : Request {
			this.options.operation = { method: "increment", field: field, value: value || 1 };
			return this.client.put(this.segments, this.buildQuery());
		}

		public function decrement(field : String, value : Object = null) : Request {
			this.options.operation = { method: "decrement", field: field, value: value || 1 };
			return this.client.put(this.segments, this.buildQuery());
		}

		public function updateAll(data : Object) : Request {
			this.options.data = data;
			return this.client.put(this.segments, this.buildQuery());
		}

		public function select(...args) : Collection {
			this.options.select = args;
			return this;
		}

		public function where(objects : Object, _operation : Object = null, _value : Object = null, bool : String = "and") : Collection {
			var field : String,
					operation : String = (_value == null) ? "=" : _operation as String,
					value : Object = (_value == null) ? _operation as String : _value;

			if (typeof(objects)==="object") {
				for (field in objects) {
					if (objects.hasOwnProperty(field)) {
						operation = "=";
						if (objects[field] is Array) {
							operation = objects[field][0];
							value = objects[field][1];
						} else {
							value = objects[field];
						}
						this.addWhere(field, operation, value, bool);
					}
				}
			} else {
				this.addWhere(objects as String, operation, value, bool);
			}

			return this;
		}

		public function orWhere(objects : Object, _operation : Object = null, _value : Object = null) : Collection {
			return this.where(objects, _operation, _value, "or");
		}

		public function join(...args) : Collection {
			this.options["with"] = args;
			return this;
		}

		public function distinct() : Collection {
			this.options.distinct = true;
			return this;
		}

		public function group(...args) : Collection {
			this._group = args;
			return this;
		}

		public function reset() : Collection {
			this.options = {};
			this.wheres = new Array();
			this.ordering = new Array();
			this._group = new Array();
			this._limit = NaN;
			this._offset = NaN;
			this._remember = NaN;
			return this;
		}

		public function sort(field : String, direction : Object = null) : Collection {
			var dir : String;

			if (direction == null) {
				direction = "asc";

			} else if (typeof(direction)==="number") {
				direction = (direction as int == -1) ? "desc" : "asc";
			}

			this.ordering.push([field, dir]);
			return this;
		}

		public function limit(i : int) : Collection {
			this._limit = i;
			return this;
		}

		public function offset(i : int) : Collection {
			this._offset = i;
			return this;
		}

		public function remember(minutes : int) : Collection {
			this._remember = minutes;
			return this;
		}

		public function addWhere(field : String, operation : String, value : Object, bool : String = "and") : Collection {
			this.wheres.push([field, operation.toLowerCase(), value, bool]);
			return this;
		}

		public function buildQuery() : Object {
			var query : Object = {};

			// apply limit / offset and remember
			if (!isNaN(this._limit)) { query.limit = this._limit; }
			if (!isNaN(this._offset)) { query.offset = this._offset; }
			if (!isNaN(this._remember)) { query.remember = this._remember; }

			// apply wheres
			if (this.wheres.length > 0) {
				query.q = this.wheres;
			}

			// apply ordering
			if (this.ordering.length > 0) {
				query.s = this.ordering;
			}

			// apply group
			if (this._group.length > 0) {
				query.g = this._group;
			}

			var f : String,
					shortnames : Object = {
					"paginate": "p",        // pagination (perPage)
					"first": "f",           // first / firstOrCreate
					"aggregation": "aggr",  // min / max / count / avg / sum
					"operation": "op",      // increment / decrement
					"data": "data",         // updateAll / firstOrCreate
					"with": "with",         // join / relationships
					"select": "select",     // fields to return
					"distinct": "distinct"  // use distinct operation
			};

			for (f in shortnames) {
				if (this.options[f]) {
					query[shortnames[f]] = this.options[f];
				}
			}

			// clear wheres/ordering for future calls
			this.reset();

			return query;
		}

		public function onSuccess(callback: Function) : Request {
			var req : Request = this.get(),
					success : Function = function(evt : ResponseEvent) : void {
						callback(evt);
						req.removeEventListener(ResponseEvent.SUCCESS, success);
					};
			req.addEventListener(ResponseEvent.SUCCESS, success);
			return req;
		}

		public function onComplete(callback: Function) : Request {
			var req : Request = this.get(),
					success : Function = function(evt : ResponseEvent) : void {
						callback(evt);
						req.removeEventListener(ResponseEvent.COMPLETE, success);
					};
			req.addEventListener(ResponseEvent.COMPLETE, success);
			return req;
		}

		public function onError(callback: Function) : Request {
			var req : Request = this.get(),
					success : Function = function(evt : ResponseEvent) : void {
						callback(evt);
						req.removeEventListener(ResponseEvent.ERROR, success);
					};
			req.addEventListener(ResponseEvent.ERROR, success);
			return req;
		}

	}

}

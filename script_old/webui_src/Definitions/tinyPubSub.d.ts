interface JQueryStatic
{
	publish(name?: string, userData?: any): void;
	subscribe(name?: string, callback?: any): void;
	unsubscribe(name?: string): void;
}

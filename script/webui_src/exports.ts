// jQuery
declare var $: any;

// Underscore.js
declare var _: any;

// Backbone.js
declare module Backbone {
    export class Model {
        constructor (attr? , opts? );
        get(name: string): any;
        set(name: string, val: any): void;
        set(obj: any): void;
        save(attr? , opts? ): void;
        destroy(): void;
        on(ev: string, f: Function, ctx?: any): void;
        off(ev?: string, f?: Function, ctx?: any): void;
        trigger(ev: string, args?: any): void;
        toJSON(): any;
    }
    export class Collection {
        constructor (models? , opts? );
        on(ev: string, f: Function, ctx?: any): void;
        off(ev?: string, f?: Function, ctx?: any): void;
        trigger(ev: string, args?: any): void;
        length: number;
        create(attrs, opts? ): any;
        each(f: (elem: any) => void ): void;
        fetch(opts?: any): void;
        last(): any;
        last(n: number): any[];
        filter(f: (elem: any) => any): any[];
        without(...values: any[]): any[];
        models(): any[];
    }
    export class View {
        constructor (options? );
        $(selector: string): any;
        el: HTMLElement;
        $el: any;
        model: Model;
        remove(): void;
        delegateEvents: any;
        make(tagName: string, attrs? , opts? ): View;
        setElement(element: HTMLElement, delegate?: bool): void;
        tagName: string;
        events: any;
        on(ev: string, f: Function, ctx?: any): void;
        off(ev?: string, f?: Function, ctx?: any): void;
        trigger(ev: string, args?: any): void;

        static extend: any;
    }
}

// Backbone.localStorage.js
declare var Store: any;

// iScroll
declare var iScroll: any;
import {Directive,Attribute} from '@angular/core';


@Directive({
     selector: '[mask]' ,
     host: {
    '(keypress)' : 'onInputChange($event)'
}
     
    })

export class MaskDirective{
     
 
    onInputChange(event:KeyboardEvent){                
        var key:string = String.fromCharCode(!event.charCode ? event.which : event.charCode);
        let sc_REGEXP = '^[a-zA-Z0-9 ]+$';
        var reg = new RegExp(sc_REGEXP)   

              if (!reg.test(key)) {
                    event.preventDefault();
                    return false;
                }
          
    }


}
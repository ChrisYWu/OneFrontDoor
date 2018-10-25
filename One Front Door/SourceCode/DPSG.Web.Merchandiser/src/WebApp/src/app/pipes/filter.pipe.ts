import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'filter'
})
export class FilterPipe implements PipeTransform {

// manage to handle error 
//debugger;

  transform(items: Array < any > , conditions: {
    [field: string]: any
  }): Array < any > {
    if (items == null){
      return items;
    }
    return items.filter(item => {
 
      for (let field in conditions) {
        //no case sensitive
        if (item[field].toLowerCase().indexOf(conditions[field].toLowerCase()) >= 0) {
          return true;
        } 
      }
      
      return false;

    });
  }

}



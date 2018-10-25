import { Pipe } from '@angular/core';

@Pipe({
    name: 'changeName'
})
export class ChangeNamePipe {
transform(value: string) {
if ((typeof value) !== 'string') {
return value;
}
value = value.split(/(?=[A-Z])/).join(' ');
value = value[0].toUpperCase() + value.slice(1);
return value;
}
}
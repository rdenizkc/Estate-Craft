import { LightningElement, wire, api } from 'lwc';
import getChildAccount from '@salesforce/apex/AccountController.getChildAccounts';
import { NavigationMixin } from 'lightning/navigation';
export default class ChildAccount extends NavigationMixin(LightningElement) {
@api recordId;
childAccounts; //after creating connection between js and apex method, data will be loaded in this property
    @wire(getChildAccount, {parentAccId: '$recordId'}) childAccounts; //data transition from database to component is done...
    navigateToViewAccountPage(event){
        var recId = event.target.name; //n
        
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: recId, //coming from html in anchor tag with name container....
                    objectApiName: 'Account',
                    actionName: 'view'
                },
            });
        }
}
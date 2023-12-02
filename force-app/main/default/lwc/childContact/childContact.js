import { LightningElement, api, wire } from 'lwc';
import getChildContOfChildAcc from '@salesforce/apex/AccountController.getChildContactOfChildAccounts';
import { NavigationMixin } from 'lightning/navigation';


export default class ChildContacts extends NavigationMixin(LightningElement) {
@api childAccountId; //will be taken from Parent Component html by the help of api decorator
relatedContacts; //local property to keep contacts coming from database
                // we use is it html to display contacts
@wire(getChildContOfChildAcc, { childAccId:'$childAccountId'}) relatedContacts;

navigateToViewContactPage(event){
    var recId = event.target.name; //name={con.Id} from html a tag...
    
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: 'Contact',
                actionName: 'view'
            },
        });
}}
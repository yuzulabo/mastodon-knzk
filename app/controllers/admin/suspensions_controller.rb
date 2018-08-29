# frozen_string_literal: true

module Admin
  class SuspensionsController < BaseController
    before_action :set_account

    def create
      authorize @account, :suspend?

      @suspension = Form::AdminSuspensionConfirmation.new(suspension_params)

      if suspension_params[:acct] == @account.acct
        resolve_report! if suspension_params[:report_id].present?
        perform_suspend!
        mark_reports_resolved!
        redirect_to admin_accounts_path
      else
        flash.now[:alert] = I18n.t('admin.suspensions.bad_acct_msg')
        render :new
      end
    end

    def destroy
      authorize @account, :unsuspend?
      @account.unsuspend!
      log_action :unsuspend, @account
      redirect_to admin_accounts_path
    end

    private

    def set_account
      @account = Account.find(params[:account_id])
    end
  end
end

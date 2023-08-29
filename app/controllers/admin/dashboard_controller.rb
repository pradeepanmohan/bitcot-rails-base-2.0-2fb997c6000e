module Admin
  class DashboardController < ApplicationController

    def index
      if params[:reset]
        redirect_to admin_dashboard_path
        return
      end
      @selected_date = if params[:selected_date].present?
                         Date.parse(params[:selected_date])
                       else
                         nil
                       end
      @date_type = params[:date_type]
      @start_date = if params[:start_date].present?
                       Date.parse(params[:start_date])
                     else
                       nil
                    end
      @end_date = if params[:end_date].present?
                      Date.parse(params[:end_date])
                    else
                      nil
                    end
      unless params[:start_date].blank?
        @date_type = "custom"
      end

      unless params[:selected_date].blank?
        @date_type = "day"
      end

      @dashboard_status_count = dashboard_status_count
      @compliance_rate = compliance_rate_info
      @compliance_vs_non_compliance_grouped = group_compliance_vs_non_compliance_data
      @compliance_progression = calculate_monthly_compliance_progression
      @organization_creation_data = calculate_organization_creation_data
      @compliance_data = compliance_chart
      @party_compliance_rate = party_conpliance_rate
      @total_compliance_data = total_compliance
      @party_compliance_data = party_progress
      @expiring_insurance_data = expiring_insurance
      @top_deficiency_data = top_deficiency
      @statics_data_user = statics_chart_user
      @statics_data_party = statics_chart_party
    end

    private

    def dashboard_status_count
      if @date_type == "month"
        @dashboard_status_count_data = Dashboarddata.find_by(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @dashboard_status_count_data = Dashboarddata.find_by(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @dashboard_status_count_data = Dashboarddata.find_by(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @dashboard_status_count_data = Dashboarddata.find_by(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @dashboard_status_count_data = Dashboarddata.last
      end

      @data = []
      @data << @dashboard_status_count_data&.compliant_count
      @data << @dashboard_status_count_data&.non_compliant_count
      @data << @dashboard_status_count_data&.no_coverage_count
      @data << @dashboard_status_count_data&.in_default_count
      @data << @dashboard_status_count_data&.expiring_insurance_count
      @data << @dashboard_status_count_data&.pending_review_count

      @data.compact!

      total_count = @data.sum
      @progress_percentages = []

      if total_count > 0
        @progress_percentages = @data.map { |count| ((count.to_f / total_count) * 100).round(2) }
      else
        @progress_percentages = [0.0] * @data.length
      end
    end


    def compliance_chart
      if @date_type == "month"
        @compliance_data = Dashboarddata.find_by(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @compliance_data = Dashboarddata.find_by(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @compliance_data = Dashboarddata.find_by(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @compliance_data = Dashboarddata.find_by(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @compliance_data = Dashboarddata.last
      end
    end

    def total_compliance
      if @date_type == "month"
        @total_compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @total_compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @total_compliance_data = Dashboarddata.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @total_compliance_data = Dashboarddata.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @total_compliance_data = Dashboarddata.all
      end
    end

    def party_conpliance_rate
      if @date_type == "month"
        @party_compliance_data = Party.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
        @party_compliance_data = @party_compliance_data.group(:status).count
      elsif @date_type == "week"
        @party_compliance_data = Party.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
        @party_compliance_data = @party_compliance_data.group(:status).count
      elsif @date_type == "custom"
        @party_compliance_data = Party.where(created_at: @start_date..@end_date)
        @party_compliance_data = @party_compliance_data.group(:status).count
      elsif @date_type == "day"
        @party_compliance_data = Party.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
        @party_compliance_data = @party_compliance_data.group(:status).count
      else
        @party_compliance_data = Party.group(:status).count
      end
    end

    def compliance_rate_info
      Dashboarddata.all.map { |x| x.month_1_compliance_rate}
    end

    def compliance_vs_non_compliance_data
      if @date_type == "month"
        @compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @compliance_data = Dashboarddata.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @compliance_data = Dashboarddata.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @compliance_data = Dashboarddata.all
      end
      data = []

      @compliance_data.each do |dashboarddata|
        data_point = {
          name: dashboarddata.created_at.strftime('%b %Y'), # Customize the label as needed
          'Compliance': dashboarddata.compliant_count,
          'Non-Compliance': dashboarddata.non_compliant_count
        }
        data << data_point
      end

      data
    end

    def group_compliance_vs_non_compliance_data

      if @date_type == "month"
        @compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @compliance_data = Dashboarddata.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @compliance_data = Dashboarddata.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @compliance_data = Dashboarddata.all
      end
      compliance_data = @compliance_data.group_by_month(:created_at).sum(:compliant_count)
      non_compliance_data = @compliance_data.group_by_month(:created_at).sum(:non_compliant_count)

      transformed_data = [
        {
          name: "Compliance",
          data: []
        },
        {
          name: "Non-Compliance",
          data: []
        }
      ]

      compliance_data.each do |month, compliance_count|
        non_compliance_count = non_compliance_data[month]
        transformed_data[0][:data] << [month.strftime('%b %Y'), compliance_count]
        transformed_data[1][:data] << [month.strftime('%b %Y'), non_compliance_count]
      end

      transformed_data
    end

    def calculate_monthly_compliance_progression
      if @date_type == "month"
        @compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @compliance_data = Dashboarddata.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @compliance_data = Dashboarddata.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @compliance_data = Dashboarddata.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @compliance_data = Dashboarddata.all
      end
      months = (1..6).to_a.map { |month| "month_#{month}_compliance_rate" }
      party_months = (1..6).to_a.map { |month| "party_month_#{month}_compliance_rate" }

      party_data = party_months.map do |month_column|
        {
          name: "Party #{month_column.split('_').last}",
          data: @compliance_data.pluck(:created_at, month_column)
        }
      end

      agreement_data = months.map do |month_column|
        {
          name: "Agreement #{month_column.split('_').last}",
          data: @compliance_data.pluck(:created_at, month_column)
        }
      end

      { parties: party_data, agreements: agreement_data }
    end

    def party_progress
      if @date_type == "month"
        @party_progress_data = Dashboarddata.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @party_progress_data = Dashboarddata.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @party_progress_data = Dashboarddata.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @party_progress_data = Dashboarddata.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @party_progress_data = Dashboarddata.all
      end

      @party_progress_chart_data = [
        { name: 'Pending Review Parties', data: @party_progress_data.group_by_week(:created_at).sum(:pending_review_parties_count) },
        { name: 'Parties with Days in Status', data: @party_progress_data.group_by_week(:created_at).sum(:parties_with_days_in_status_over_a_month) },
        { name: 'Expired Parties over 90 Days', data: @party_progress_data.group_by_week(:created_at).sum(:expired_parties_over_ninety_days) },
        { name: 'Expiring Parties over 90 Days', data: @party_progress_data.group_by_week(:created_at).sum(:expiring_parties_over_ninety_days) },
        { name: 'Parties Defaulted in Last 90 Days', data: @party_progress_data.group_by_week(:created_at).sum(:parties_defaulted_last_ninety_days) }
      ]
    end


    def statics_chart_user
      if @date_type == "month"
        @statics_data_user = User.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @statics_data_user = User.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @statics_data_user = User.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @statics_data_user = User.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @statics_data_user = User.all
      end
    end

    def statics_chart_party
      if @date_type == "month"
        @statics_data_party = Party.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @statics_data_party = Party.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @statics_data_party = Party.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @statics_data_party = Party.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @statics_data_party = Party.all
      end
    end

    def top_deficiency
      if @date_type == "month"
        @top_deficiency_data = Dashboarddata.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @top_deficiency_data = Dashboarddata.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @top_deficiency_data = Dashboarddata.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @top_deficiency_data = Dashboarddata.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @top_deficiency_data = Dashboarddata.all
      end
    end

    def expiring_insurance
      if @date_type == "month"
        @expiring_insurance_data = Dashboarddata.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @expiring_insurance_data = Dashboarddata.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @expiring_insurance_data = Dashboarddata.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @expiring_insurance_data = Dashboarddata.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @expiring_insurance_data = Dashboarddata.all
      end
    end


    def calculate_organization_creation_data
      if @date_type == "month"
        @compliance_data = Organization.where(created_at: Date.today.beginning_of_month..Date.today.end_of_month)
      elsif @date_type == "week"
        @compliance_data = Organization.where(created_at: Date.today.beginning_of_week..Date.today.end_of_week)
      elsif @date_type == "custom"
        @compliance_data = Organization.where(created_at: @start_date..@end_date)
      elsif @date_type == "day"
        @compliance_data = Organization.where(created_at: @selected_date.beginning_of_day..@selected_date.end_of_day)
      else
        @compliance_data = Organization.all
      end
      created_at_data = @compliance_data.group_by_month(:created_at).count
      formatted_data = created_at_data.map { |month, count| [month.strftime('%Y-%m-%d'), count] }
      formatted_data
    end
  end
end
